function Get-CASchema {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('PKI.CertificateServices.DB.Schema[]')]
[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias('CA')]
		[PKI.CertificateServices.CertificateAuthority[]]$CertificationAuthority,
		[PKI.CertificateServices.DB.TableList]$Table = [PKI.CertificateServices.DB.TableList]::Request
	)
	process {
		foreach ($CA in $CertificationAuthority) {
			$CA.GetSchema($Table)
		}
	}
}