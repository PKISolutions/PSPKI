function Get-RequestArchivedKey {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Cryptography.Pkcs.DefaultSignedPkcs7')]
[CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [SysadminsLV.PKI.Management.CertificateServices.Database.AdcsDbRow[]]$Request
    )
    begin {
        Assert-CommandRequirement $PREREQ_RSAT -ErrorAction Stop
    }

    process {
        foreach ($req in $Request) {
            $CertAdmin = New-Object -ComObject CertificateAuthority.Admin
            try {
                $base64 = $CertAdmin.GetArchivedKey($req.ConfigString, $req.RowID, 1)
                $bytes = [convert]::FromBase64String($base64)
                New-Object SysadminsLV.PKI.Cryptography.Pkcs.DefaultSignedPkcs7 (,$bytes)
            } catch {
                Write-Error -Exception $_.Exception
            } finally {
                Clear-ComObject $CertAdmin
            }
        }
    }
}