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
		$Reasons = @{"Unspecified"=0;"KeyCompromise"=1;"CACompromise"=2;"AffiliationChanged"=3;"Superseded"=4;
			"CeaseOfOperation"=5;"Hold"=6;"ReleaseFromCRL"=8;"Unrevoke"=-1}
	}
	process {
		if ([string]::IsNullOrEmpty($Request.SerialNumber)) {
			throw New-Object InvalidOperationException
		}
		$CertAdmin = New-Object -ComObject CertificateAuthority.Admin
		if ($Request.SerialNumber.Length % 2) {$Request.Serialnumber = "0" + $Request.Serialnumber}
		try {
			$CertAdmin.RevokeCertificate($Request.ConfigString,$Request.SerialNumber,$Reasons[$Reason],$RevocationDate.ToUniversalTime())
			New-Object PKI.Utils.ServiceOperationResult 0,
				"Successfully revoked certificate with ID=$($Request.RequestID) and reason: '$Reason'"
		} catch {
			New-Object PKI.Utils.ServiceOperationResult $_.Exception.HResult
		} finally {
			[void][Runtime.InteropServices.Marshal]::ReleaseComObject($CertAdmin)
		}
		
	}
}