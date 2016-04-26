function Get-DatabaseRow {
<#
.ExternalHelp PSPKI.Help.xml
#>
[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias('CA')]
		[PKI.CertificateServices.CertificateAuthority[]]$CertificationAuthority,
		[PKI.CertificateServices.DB.TableList]$Table = "Request",
		[Alias('ID')]
		[int[]]$RowID,
		[Alias("Properties", "IncludeProperty", "IncludeProperties", "IncludedProperty", "IncludedProperties")]
		[String[]]$Property,
		[String[]]$Filter
	)
	begin {
		$IdColumn = switch ($Table) {
			"Request"	{"RequestID"}
			"Extension"	{"ExtensionRequestId"}
			"Attribute"	{"AttributeRequestId"}
			"CRL"		{"CRLRowId"}
		}
	}
	process {
		foreach ($CA in $CertificationAuthority) {
			try {
				$Schema = $CA.GetSchema($Table)
			} catch {
				Write-Error $_
				continue
			}
			if ($RowID -ne $null) {
				$RowID | ForEach-Object {Get-RequestRow -CA $CA -Property $Property -Table $Table -Filter "$IdColumn -eq $_" -Schema $Schema}
			} else {
				Get-RequestRow -CA $CA -Property $Property -Table $Table -Filter $Filter -Schema $Schema
			}
		}
	}
}