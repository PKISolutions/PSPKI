function Remove-AuthorityInformationAccess {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('PKI.CertificateServices.AuthorityInformationAccess')]
[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[PKI.CertificateServices.AuthorityInformationAccess[]]$InputObject,
		[String[]]$URI
	)
	process {
		foreach ($AIA in $InputObject) {
			if ($URI -contains "*") {
				$AIA.URI = $null
			} else {
				foreach ($url in $URI) {$AIA.URI = $AIA.URI | Where-Object {$_.RegUri -notlike $url}}
			}
			$AIA
		}
	}
}