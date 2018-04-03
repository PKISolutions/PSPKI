function Get-RequestRow {
[CmdletBinding()]
    param(
        $CA,
        [String[]]$Property,
        [string]$Table,
        [String[]]$Filter,
        [PKI.CertificateServices.DB.Schema[]]$Schema
    )
function __handleOidColumns($Row) {
    # handle strongly OID values: add value as is and add extra backing property with resolved
    # OID=Value pair.
    if ($Row.Properties.ContainsKey("CertificateTemplate")) {
        $Row.Properties.Add("CertificateTemplateOid", [Security.Cryptography.Oid]$Row.Properties["CertificateTemplate"])
    }
    if ($Row.Properties.ContainsKey("ExtensionName")) {
        $Row.Properties.Add("ExtensionNameOid", [Security.Cryptography.Oid]$Row.Properties["ExtensionName"])
    }
}
    if (!$CA.Ping()) {
        Write-ErrorMessage -Source ICertAdminUnavailable -ComputerName $CA.ComputerName
        return
    }
    $CaView = New-Object -ComObject CertificateAuthority.View
    $CaView.OpenConnection($CA.ConfigString)
    $RColumn = $CaView.GetColumnIndex(0, "Disposition")
# set proper table
    switch ($Table) {
        "Revoked"	{$CaView.SetRestriction($RColumn,1,0,21)}
        "Issued"	{$CaView.SetRestriction($RColumn,1,0,20)}
        "Pending"	{$CaView.SetRestriction($RColumn,1,0,9)}
        "Failed"	{$CaView.SetRestriction(-3,0,0,0)}
        "Extension"	{$CaView.SetTable(0x3000)}
        "Attribute"	{$CaView.SetTable(0x4000)}
        "CRL"		{$CaView.SetTable(0x5000)}
    }
# parse restriction filters
    if ($Filter -ne $null) {
        foreach ($line in $Filter) {
            if ($line -notmatch "^(.+)\s(-eq|-lt|-le|-ge|-gt)\s(.+)$") {
                [void][Runtime.InteropServices.Marshal]::ReleaseComObject($CaView)
                throw "Malformed filter: '$line'"
            }
            try {
                $Rcolumn = $CaView.GetColumnIndex($false, $matches[1])
            } catch {
                [void][Runtime.InteropServices.Marshal]::ReleaseComObject($CaView)
                throw "Specified column '$($matches[1])' does not exist."
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
            $Value = switch ([int]$SchemaRow.DataType) {
                1		{$matches[3] -as [int]}
                2		{[DateTime]::ParseExact($matches[3],"MM/dd/yyyy HH:mm:ss",[Globalization.CultureInfo]::InvariantCulture)}
                default	{$matches[3]}
            }
            if ($matches[1] -eq "CertificateTemplate") {
                if ($Value -ne "Machine") {
                    $Value = ([Security.Cryptography.Oid]$Value).Value
                }
            }
            try {
                $CaView.SetRestriction($RColumn,$Seek,0,$Value)
            } catch {
                Write-Warning "Specified pattern '$line' is not valid."
                [void][Runtime.InteropServices.Marshal]::ReleaseComObject($CaView)
                throw "Specified pattern '$line' is not valid."
            }
        }
    }
# set output columns
    if ($Property -contains "*") {
        $ColumnCount = $CaView.GetColumnCount(0)
        $CaView.SetResultColumnCount($ColumnCount)
        0..($ColumnCount - 1) | ForEach-Object {$CaView.SetResultColumn($_)}
    } else {
        $properties = switch ($Table) {
            "Revoked"	{"RequestID","Request.RevokedWhen","Request.RevokedReason","CommonName","SerialNumber","CertificateTemplate"}
            "Issued"	{"RequestID","Request.RequesterName","CommonName","NotBefore","NotAfter","SerialNumber","CertificateTemplate"}
            "Pending"	{"RequestID","Request.RequesterName","Request.SubmittedWhen","Request.CommonName","CertificateTemplate"}
            "Failed"	{"RequestID","Request.StatusCode","Request.DispositionMessage","Request.SubmittedWhen","Request.CommonName","CertificateTemplate"}
            "Request"	{"RequestID","Request.StatusCode","Request.DispositionMessage","Request.RequesterName","Request.SubmittedWhen","Request.CommonName","CertificateTemplate"}
            "Extension" {"ExtensionRequestId","ExtensionName","ExtensionFlags","ExtensionRawValue"}
            "Attribute" {"AttributeRequestId","AttributeName","AttributeValue"}
            "CRL"		{"CRLRowId","CRLNumber","CRLThisUpdate","CRLNextUpdate","CRLPublishStatusCode","CRLPublishError"}
        }
        $properties = $properties + $Property | Select-Object -Unique | Where-Object {$_}
        $CaView.SetResultColumnCount($properties.Count)
        $properties | ForEach-Object {$CaView.SetResultColumn($CaView.GetColumnIndex(0, $_))}
    }
# process search routine
    $DbRow = $CaView.OpenView()
    while ($DbRow.Next() -ne -1) {
        $Row = New-Object PKI.CertificateServices.DB.RequestRow
        $Row.ConfigString = $CA.ConfigString
        $Row.Table = switch ($Table) {
            "Extension"	{[PKI.CertificateServices.DB.TableList]::Extension}			
            "Attribute"	{[PKI.CertificateServices.DB.TableList]::Attribute}
            "CRL"		{[PKI.CertificateServices.DB.TableList]::CRL}
            default		{[PKI.CertificateServices.DB.TableList]::Request}
        }
        $DbColumn = $DbRow.EnumCertViewColumn()
        while ($DbColumn.Next() -ne -1) {
            $colName = $DbColumn.GetName()
            $colVal = $DbColumn.GetValue(1)
            if (
                $colName -eq "RequestID"			-or
                $colName -eq "ExtensionRequestId"	-or
                $colName -eq "AttributeRequestId"	-or
                $colName -eq "CRLRowId"
            ) {
                $Row.RowId = $colVal
            }            
            $Row.Properties.Add($colName, $colVal)
            # deprecated!
            $Row | Add-Member -MemberType NoteProperty $colName -Value $colVal -Force            
        }
        if ($Row.CertificateTemplate -match "^(\d+\.){3}") {
            if ([string]::IsNullOrEmpty(([Security.Cryptography.Oid]$colVal).FriendlyName)) {
                $Row.CertificateTemplate = $colVal
            } else {
                $Row.CertificateTemplate = ([Security.Cryptography.Oid]$colVal).FriendlyName
            }
        }
        __handleOidColumns $Row
        $Row
        [void][Runtime.InteropServices.Marshal]::ReleaseComObject($DbColumn)
    }
    $CaView, $DbRow | ForEach-Object {[void][Runtime.InteropServices.Marshal]::ReleaseComObject($_)}
    Remove-Variable CaView, Row
}