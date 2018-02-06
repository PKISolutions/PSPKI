function Set-CATemplate {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('PKI.CertificateServices.CATemplate[]')]
[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
		[PKI.CertificateServices.CATemplate[]]$InputObject
	)
	process {
		foreach ($CATemplate in $InputObject) {
			try {
				$Status = $CATemplate.SetInfo()
				if (!$Status) {Write-Verbose $NothingIsSet}
				$CATemplate
			} finally { }
		}
	}
}