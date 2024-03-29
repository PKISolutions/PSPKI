function Submit-CertificateRequest {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('PKI.Enrollment.CertRequestStatus')]
[CmdletBinding(DefaultParameterSetName = '__dcom')]
    param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string[]]$Path,
        [Parameter(Mandatory = $true, ParameterSetName = '__dcom')]
        [Alias('CA')]
        [PKI.CertificateServices.CertificateAuthority]$CertificationAuthority,
        [Parameter(Mandatory = $true, ParameterSetName = '__xcep')]
        [Alias('CEP')]
        [PKI.Enrollment.Policy.PolicyServerClient]$EnrollmentPolicyServer,
        [System.Management.Automation.PSCredential]$Credential,
        [String[]]$Attribute
    )
    begin {
        $ErrorActionPreference = "Stop"
        $CertRequest = New-Object -ComObject CertificateAuthority.Request
        switch ($PsCmdlet.ParameterSetName) {
            "__xcep" {
                if (![string]::IsNullOrEmpty($Credential.UserName)) {
                    switch ($EnrollmentPolicyServer.Authentication) {
                        "UserNameAndPassword" {
                            $CertRequest.SetCredential(
                                0,
                                [int]$EnrollmentPolicyServer.Authentication,
                                $Credential.UserName,
                                [Runtime.InteropServices.Marshal]::PtrToStringAuto(
                                    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($Credential.Password)
                                )
                            )
                        }
                        "ClientCertificate" {
                            $CertRequest.SetCredential(
                                0,
                                [int]$EnrollmentPolicyServer.Authentication,
                                $Credential.UserName,
                                $null
                            )
                        }
                    }
                }
            }
            "__dcom" {
                if (!$CertificationAuthority.PingRequest()) {
                    $e = New-Object SysadminsLV.PKI.Exceptions.ServerUnavailableException $CertificationAuthority.DisplayName
                    throw $e
                }
            }
        }
        if ($Attribute -eq $null) {
            $strAttribute = [string]::Empty
        } else {
            $SB = New-Object Text.StringBuilder
            foreach ($attrib in $Attribute) {
                [Void]$SB.Append($attrib + "`n")
            }
            $strAttribute = $SB.ToString()
            $strAttribute = $strAttribute.Substring(0,$strAttribute.Length - 1)
        }
    }
    process {
        $Path | ForEach-Object {
            try {
                $Request = [IO.File]::ReadAllText((Resolve-Path $_).ProviderPath)
                $Status = $CertRequest.Submit(0xff,$Request,$strAttribute,$CertificationAuthority.ConfigString)
                $Output = New-Object PKI.Enrollment.CertRequestStatus -Property @{
                    CertificationAuthority = $CertificationAuthority;
                    Status = $Status;
                    RequestID = $CertRequest.GetRequestId()
                }
                if ($Status -eq 3) {
                    $base64 = $CertRequest.GetCertificate(1)
                    $Output.Certificate = New-Object Security.Cryptography.X509Certificates.X509Certificate2 (,[Convert]::FromBase64String($base64))
                } else {
                    $Output.ErrorInformation = $CertRequest.GetDispositionMessage()
                }
                $Output
            } catch {throw $_}
        }
    }
}