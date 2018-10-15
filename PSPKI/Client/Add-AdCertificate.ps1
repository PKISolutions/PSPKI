function Add-AdCertificate {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('[SysadminsLV.PKI.Management.ActiveDirectory.DsPkiContainer]')]
[CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [SysadminsLV.PKI.Management.ActiveDirectory.DsPkiCertContainer]$AdContainer,
        [Parameter(Mandatory = $true)]
        [Security.Cryptography.X509Certificates.X509Certificate2[]]$Certificate,
        [switch]$CrossCA,
        [switch]$Dispose
    )
    if ($Certificate.Length -gt 0) {
        $Certificate | ForEach-Object {
            if ($Adcontainer -is [SysadminsLV.PKI.Management.ActiveDirectory.DsAiaContainer]) {
                $type = if ($CrossCA) {"CrossCertificate"} else {"CACertificate"}
                [void]$AdContainer.AddCertificate($_, $type)
            } else {
                [void]$AdContainer.AddCertificate($_)
            }
        }
        $AdContainer.SaveChanges($false)
    }
    if ($Dispose) {
        $AdContainer.Dispose()
    }
    $AdContainer
}