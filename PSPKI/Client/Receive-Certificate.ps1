function Receive-Certificate {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('System.Security.Cryptography.X509Certificates.X509Certificate2Collection')]
[CmdletBinding(DefaultParameterSetName = '__direct')]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = '__direct')]
        [ValidateScript({
            if ($_.GetType().FullName -eq "SysadminsLV.PKI.Management.CertificateServices.Database.AdcsDbRow") {$true} else {$false}
        })]$RequestRow,
        [Parameter(ValueFromPipeline = $true, ParameterSetName = '__xcep')]
        [Alias('CEP')]
        [PKI.Enrollment.Policy.PolicyServerClient]$EnrollmentPolicyServer,
        [Parameter(ParameterSetName = '__xcep')]
        [System.Management.Automation.PSCredential]$Credential,
        [IO.DirectoryInfo]$Path,
        [switch]$IncludeChain,
        [switch]$Force
    )
    begin {
        $CR_OUT_BASE64HEADER = 0
        $CR_OUT_BASE64 = 1
        $CR_OUT_CHAIN = 0x100
        $ErrorActionPreference = "Stop"
        $CertRequest = New-Object -ComObject CertificateAuthority.Request
        switch ($PsCmdlet.ParameterSetName) {
            "__xcep" {
                if ($EnrollmentPolicyServer.Authentication -eq "UserNameAndPassword") {
                    if ($Credential -eq $null) {
                        throw New-Object ArgumentNullException "Credential"
                    }
                    if ($Credential.Password.Length -eq 0) {
                        $CertRequest.SetCredential(0,$EnrollmentPolicyServer.Authentication,$Credential.UserName,$null)
                    } else {
                        $CertRequest.SetCredential(
                            0,
                            $EnrollmentPolicyServer.Authentication,
                            $Credential.UserName,
                            [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Credential.Password))
                        )
                    }
                }
            }
        }
        if ($Path) {
            if (!(Test-Path $Path)) {
                [void](New-Item -ItemType Directory -Path $Path -ErrorAction Stop)
            }
        }
    }
    process {
        $RequestRow | ForEach-Object {
            $req = $_
            try {
                $Status = switch ($PsCmdlet.ParameterSetName) {
                    "__direct" {$CertRequest.RetrievePending($req.RequestID, $req.ConfigString)}
                    "__xcep" {$CertRequest.RetrievePending($req.RequestID, $EnrollmentPolicyServer.URL.AbsoluteUri)}
                }
                $Status = $CertRequest.RetrievePending($req.RequestID, $req.ConfigString)
                if ($Status -eq 3 -or $Status -eq 6) {
                    if ($Path) {
                        $flags = $CR_OUT_BASE64HEADER
                        $ext = "cer"
                        if ($IncludeChain) {
                            $flags = $CR_OUT_BASE64 -bor $CR_OUT_CHAIN
                            $ext = "p7b"
                        }
                        $Base64 = $CertRequest.GetCertificate($flags)
                        if ($IncludeChain) {
                            $bin = [convert]::FromBase64String($Base64)
                            $Base64 = [SysadminsLV.Asn1Parser.AsnFormatter]::BinaryToString($bin, "PemPkcs7", "CRLF", 0, 0)
                        }
                        $FileName = Join-Path $Path RequestID_$($req.RequestID).$ext
                        Set-Content -Path $FileName -Value $Base64 -Encoding Ascii -Force:$Force
                        $CertCol = New-Object Security.Cryptography.X509Certificates.X509Certificate2Collection
                        $CertCol.Import($FileName)
                        $CertCol
                    } else {
                        $flags = $CR_OUT_BASE64
                        if ($IncludeChain) {
                            $flags = $CR_OUT_BASE64 -bor $CR_OUT_CHAIN
                        }                        
                        $Base64 = $CertRequest.GetCertificate($flags)
                        $CertCol = New-Object Security.Cryptography.X509Certificates.X509Certificate2Collection
                        $CertCol.Import([Convert]::FromBase64String($Base64))
                        $CertCol
                    }
                } else {
                    Write-Error -Message ("The certificate for request ID = '$($req.RequestID)' is not issued. Request status is: {0}." -f [PKI.Enrollment.EnrollmentStatusEnum]$Status)
                }
            } catch {Write-Error $_}
        }
    }
    end { }
}