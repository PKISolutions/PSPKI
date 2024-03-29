function Get-CACryptographyConfig {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('PKI.CertificateServices.CACryptography')]
[CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Alias('CA')]
        [PKI.CertificateServices.CertificateAuthority[]]$CertificationAuthority
    )
    process {
        foreach ($CA in $CertificationAuthority) {
            New-Object PKI.CertificateServices.CACryptography -ArgumentList $CA
        }
    }
}