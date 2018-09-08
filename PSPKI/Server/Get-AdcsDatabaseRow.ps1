function Get-AdcsDatabaseRow {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Management.CertificateServices.Database.AdcsDbRow[]')]
[CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('CA')]
        [PKI.CertificateServices.CertificateAuthority[]]$CertificationAuthority,
        [SysadminsLV.PKI.Management.CertificateServices.Database.AdcsDbViewTableName]$Table = "Request",
        [Alias('ID')]
        [int[]]$RowID,
        [Alias("Properties", "IncludeProperty", "IncludeProperties", "IncludedProperty", "IncludedProperties")]
        [String[]]$Property,
        [String[]]$Filter
    )
    begin {
        $IdColumn = switch ($Table) {
            {($_ -eq "Request") `
                -or ($_ -eq "Revoked") `
                -or ($_ -eq "Issued") `
                -or ($_ -eq "Pending") `
                -or ($_ -eq "Failed")}
                        {"RequestID"}
            "Extension"	{"ExtensionRequestId"}
            "Attribute"	{"AttributeRequestId"}
            "CRL"		{"CRLRowId"}
        }
    }
    process {
        foreach ($CA in $CertificationAuthority) {
             try {
                $Reader = $CA.GetDbReader($Table)
                $Schema = $Reader.GetTableSchema()
            } catch {
                Write-Error $_
                continue
            } finally {
                if ($Reader -ne $null) {
                    $Reader.Dispose()
                }
            }
            if ($Table -eq "Request" -or $Table -eq "CRL") {
                # 'Request' and 'CRL' tables return single row item per RowID. If RowID is specified, all
                # other filters are ignored, because exact row is requested. This is by design.
                if ($RowID -ne $null) {
                    $RowID | ForEach-Object {
                        $Reader = $CA.GetDbReader($Table)
                        Get-RequestRow -Reader $Reader -Property $Property -Filter "$IdColumn -eq $_" -Schema $Schema
                    }
                } else {
                    $Reader = $CA.GetDbReader($Table)
                    Get-RequestRow -Reader $Reader -Property $Property -Filter $Filter -Schema $Schema
                }
            } else {
                # 'Extension' or 'Attribute' tables may return multiple objects for single RowID. Therefore,
                # if one of these tables is used and RowID is specified, silently append RowID filter to
                # existing filter list to allow 2nd level filtering.
                if ($RowID -ne $null) {
                    $RowID | ForEach-Object {
                        $Reader = $CA.GetDbReader($Table)
                        $Filter += "$IdColumn -eq $_"
                        Get-RequestRow -Reader $Reader -Property $Property -Filter $Filter -Schema $Schema
                        #$Filter = $Filter[0..($Filter.Length - 2)]
                    }
                } else {
                    $Reader = $CA.GetDbReader($Table)
                    Get-RequestRow -Reader $Reader -Property $Property -Filter $Filter -Schema $Schema
                }
            }
        }
    }
}