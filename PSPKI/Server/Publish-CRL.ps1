function Publish-CRL {
<#
.ExternalHelp PSPKI.Help.xml
#>
[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias('CA')]
		[PKI.CertificateServices.CertificateAuthority[]]$CertificationAuthority,
		[switch]$DeltaOnly,
		[switch]$UpdateFile
	)
	process {
		foreach ($CA in $CertificationAuthority) {
			$CA.PublishCRL($DeltaOnly, $UpdateFile)
		}
	}
}