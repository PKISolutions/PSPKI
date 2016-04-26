function Stop-CertificationAuthority {
<#
.ExternalHelp PSPKI.Help.xml
#>
[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias('CA')]
		[PKI.CertificateServices.CertificateAuthority[]]$CertificationAuthority
	)
	process {
		foreach ($CA in $CertificationAuthority) {
			$CA.Stop()
		}
	}
}