function Receive-Certificate {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('System.Security.Cryptography.X509Certificates.X509Certificate2')]
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
        [switch]$Force
    )
    begin {
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
                        $Base64 = $CertRequest.GetCertificate(0)
                        Set-Content -Path (Join-Path $Path RequestID_$($req.RequestID).cer) -Value $Base64 -Encoding Ascii -Force:$Force
                        New-Object Security.Cryptography.X509Certificates.X509Certificate2 -ArgumentList (Join-Path $Path RequestID_$($req.RequestID).cer)
                    } else {
                        $Base64 = $CertRequest.GetCertificate(1)
                        New-Object Security.Cryptography.X509Certificates.X509Certificate2 -ArgumentList (,[Convert]::FromBase64String($Base64))
                    }
                } else {
                    Write-Error -Message ("The certificate for request ID = '$($req.RequestID)' is not issued. Request status is: {0}." -f [PKI.Enrollment.EnrollmentStatusEnum]$Status)
                }
            } catch {Write-Error $_}
        }
    }
    end { }
}