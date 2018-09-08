function Get-RequestRow {
[CmdletBinding()]
    param(
        [SysadminsLV.PKI.Management.CertificateServices.Database.AdcsDbReader]$Reader,
        [int]$Page,
        [int]$PageSize = [int]::MaxValue,
        [String[]]$Property,
        [String[]]$Filter,
        [SysadminsLV.PKI.Management.CertificateServices.Database.AdcsDbColumnSchema[]]$Schema
    )
    $ErrorActionPreference = "Stop"
# parse restriction filters
    if ($Filter -ne $null) {
        foreach ($line in $Filter) {
            if ($line -notmatch "^(.+)\s(-eq|-lt|-le|-ge|-gt)\s(.+)$") {
                $Reader.Dispose()
                throw "Malformed filter: '$line'"
            }
            $Seek = switch ($matches[2]) {
                "-eq" {1}
                "-lt" {2}
                "-le" {4}
                "-ge" {8}
                "-gt" {16}
            }
            $Value = $matches[3]
            $SchemaRow = $Schema | Where-Object {$_.Name -eq $matches[1]}
            if ($SchemaRow -eq $null) {
                throw "Specified column '$($matches[1])' is not found."
            }
            $Value = switch ($SchemaRow.DataType) {
                "Long"     {$matches[3] -as [int]}
                "DateTime" {[DateTime]::ParseExact($matches[3],"MM/dd/yyyy HH:mm:ss",[Globalization.CultureInfo]::InvariantCulture)}
                default    {$matches[3]}
            }
            if ($matches[1] -eq "CertificateTemplate") {
                if ($Value -ne "Machine") {
                    $Value = ([Security.Cryptography.Oid]$Value).Value
                }
            }
            $f = New-Object SysadminsLV.PKI.Management.CertificateServices.Database.AdcsDbQueryFilter $SchemaRow.Name, $Seek, $Value
            [void]$Reader.AddQueryFilter($f)
        }
    }

    #set output columns
    $Property | Where-Object {$_} | ForEach-Object {
        [void]$Reader.AddColumnToView($_)
    }
    try {
        $skip = ($Page - 1) * $PageSize
        $Reader.GetView($skip, $PageSize) | ForEach-Object {
            foreach ($key in $_.Properties.Keys) {
                $_ | Add-Member -MemberType NoteProperty $key -Value $_.Properties[$key] -Force
            }
            Write-Output $_
        }
    } finally {
        $Reader.Dispose()
    }
}