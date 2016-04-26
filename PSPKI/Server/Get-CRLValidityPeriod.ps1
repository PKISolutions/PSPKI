function Get-CRLValidityPeriod {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('PKI.CertificateServices.CRLValiditySetting[]')]
[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias('CA')]
		[PKI.CertificateServices.CertificateAuthority[]]$CertificationAuthority
	)
	process {
		foreach ($CA in $CertificationAuthority) {
			New-Object PKI.CertificateServices.CRLValiditySetting -ArgumentList $CA
		}
	}
}