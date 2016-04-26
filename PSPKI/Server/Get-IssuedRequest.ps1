function Get-IssuedRequest {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('PKI.CertificateServices.DB.RequestRow[]')]
[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias('CA')]
		[PKI.CertificateServices.CertificateAuthority[]]$CertificationAuthority,
		[ValidateRange(2,2147483647)]
		[Alias('ID')]
		[int[]]$RequestID,
		[Alias("Properties", "IncludeProperty", "IncludeProperties", "IncludedProperty", "IncludedProperties")]
		[String[]]$Property,
		[String[]]$Filter
	)
	process {
		foreach ($CA in $CertificationAuthority) {
			try {
				$Schema = $CA.GetSchema()
			} catch {
				Write-Error $_
				continue
			}
			if ($RequestID -ne $null) {
				$RequestID | ForEach-Object {Get-RequestRow -CA $CA -Property $Property -Table "Issued" -Filter "RequestID -eq $_" -Schema $Schema}
			} else {
				Get-RequestRow -CA $CA -Property $Property -Table "Issued" -Filter $Filter -Schema $Schema
			}
		}
	}
}