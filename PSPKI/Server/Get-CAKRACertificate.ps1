function Get-CAKRACertificate {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('PKI.CertificateServices.KRA')]
[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias('CA')]
		[PKI.CertificateServices.CertificateAuthority[]]$CertificationAuthority
	)
	process {
		foreach ($CA in $CertificationAuthority) {
			New-Object PKI.CertificateServices.KRA -ArgumentList $CA
		}
	}
}