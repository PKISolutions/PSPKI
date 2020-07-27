function Remove-CRLDistributionPoint {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('PKI.CertificateServices.CRLDistributionPoint')]
[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[PKI.CertificateServices.CRLDistributionPoint[]]$InputObject,
		[String[]]$URI
	)
	process {
		foreach ($CDP in $InputObject) {
			if ($URI -contains "*") {
				$CDP.URI = $null
			} else {
				foreach ($url in $URI) {$CDP.URI = $CDP.URI | Where-Object {$_.RegUri -notlike $url}}
			}
			$CDP
		}
	}
}