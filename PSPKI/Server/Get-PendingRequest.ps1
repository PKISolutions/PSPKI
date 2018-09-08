function Get-PendingRequest {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Management.CertificateServices.Database.AdcsDbRow[]')]
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
    begin {
        $Table = "Pending"
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
            if ($RequestID -ne $null) {
                $RequestID | ForEach-Object {
                    $Reader = $CA.GetDbReader($Table)
                    Get-RequestRow -Reader $Reader -Property $Property -Filter "RequestID -eq $_" -Schema $Schema
                }
            } else {
                $Reader = $CA.GetDbReader($Table)
                Get-RequestRow -Reader $Reader -Property $Property -Filter $Filter -Schema $Schema
            }
        }
    }
}