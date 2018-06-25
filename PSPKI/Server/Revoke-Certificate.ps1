function Revoke-Certificate {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('PKI.Utils.IServiceOperationResult')]
[CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateScript({
            if ($_.GetType().FullName -eq "PKI.CertificateServices.DB.RequestRow") {$true} else {$false}
        })]$Request,
        [ValidateSet("Unspecified","KeyCompromise","CACompromise","AffiliationChanged",
            "Superseded","CeaseOfOperation","Hold","Unrevoke")]
        [string]$Reason = "Unspecified",
        [datetime]$RevocationDate = [datetime]::Now
    )
    begin {
        $Reasons = @{
            "Unspecified"        = 0;
            "KeyCompromise"      = 1;
            "CACompromise"       = 2;
            "AffiliationChanged" = 3;
            "Superseded"         = 4;
            "CeaseOfOperation"   = 5;
            "Hold"               = 6;
            "ReleaseFromCRL"     = 8;
            "Unrevoke"           = -1
        }
        $ConfigString = ""
        $CertAdmin = New-Object -ComObject CertificateAuthority.Admin
    }
    process {
        if ([string]::IsNullOrEmpty($Request.SerialNumber)) {
            New-Object SysadminsLV.PKI.Utils.ServiceOperationResult 0x80094003 -Property @{
                InnerObject = $Request.RequestID
            }
        }
        # if this is first item in pipeline, then $ConfigString is null.
        # cache new config string and instantiate ICertAdmin.
        # do the same if config string doesn't match cached one.
        if (!$ConfigString -or ($ConfigString -ne $Request.ConfigString)) {
            $ConfigString = $Request.ConfigString
            [PKI.Utils.CryptographyUtils]::ReleaseCom($CertAdmin)
            $CertAdmin = New-Object -ComObject CertificateAuthority.Admin
        }
        if ($Request.SerialNumber.Length % 2) {$Request.Serialnumber = "0" + $Request.Serialnumber}
        try {
            $CertAdmin.RevokeCertificate($Request.ConfigString,$Request.SerialNumber,$Reasons[$Reason],$RevocationDate.ToUniversalTime())
            New-Object SysadminsLV.PKI.Utils.ServiceOperationResult 0,
                "Successfully revoked certificate with ID=$($Request.RequestID) and reason: '$Reason'"
        } catch {
            New-Object SysadminsLV.PKI.Utils.ServiceOperationResult $_.Exception.HResult
        }
    }
    end {
        [PKI.Utils.CryptographyUtils]::ReleaseCom($CertAdmin)
    }
}