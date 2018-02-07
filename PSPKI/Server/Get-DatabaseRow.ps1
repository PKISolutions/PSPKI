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
			if ($Table -eq "Request" -or $Table -eq "CRL") {
				# 'Request' and 'CRL' tables return single row item per RowID. If RowID is specified, all
				# other filters are ignored, because exact row is requested. This is by design.
				if ($RowID -ne $null) {
					$RowID | ForEach-Object {Get-RequestRow -CA $CA -Property $Property -Table $Table -Filter "$IdColumn -eq $_" -Schema $Schema}
				} else {
					Get-RequestRow -CA $CA -Property $Property -Table $Table -Filter $Filter -Schema $Schema
				}
			} else {
				# 'Extension' or 'Attribute' tables may return multiple objects for single RowID. Therefore,
				# if one of these tables is used and RowID is specified, silently append RowID filter to
				# existing filter list to allow 2nd level filtering.
				if ($RowID -ne $null) {
					$RowID | ForEach-Object {
						$Filter += "$IdColumn -eq $_"
						Get-RequestRow -CA $CA -Property $Property -Table $Table -Filter $Filter -Schema $Schema
					}
				} else {
					Get-RequestRow -CA $CA -Property $Property -Table $Table -Filter $Filter -Schema $Schema
				}
			}
		}
	}
}