function Get-RequestArchivedKey {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Cryptography.Pkcs.DefaultSignedPkcs7')]
[CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [SysadminsLV.PKI.Management.CertificateServices.Database.AdcsDbRow[]]$Request,
        # this parameter is optional.
        [System.IO.FileInfo]$OutFile
    )

    process {
        foreach ($req in $Request) {
            $CertAdmin = New-Object -ComObject CertificateAuthority.Admin
            try {
                $base64 = $CertAdmin.GetArchivedKey($_.ConfigString)
                $cms = New-Object SysadminsLV.PKI.Cryptography.Pkcs.DefaultSignedPkcs7 (,$base64)
                if ($OutFile) {
                    Export-Binary $OutFile.FullName $cms.RawData
                }

                $cms
            } finally {
                Release-COM $CertAdmin
            }
        }
    }
}