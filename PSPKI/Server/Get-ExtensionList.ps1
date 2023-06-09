function Get-ExtensionList {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('PKI.CertificateServices.PolicyModule.ExtensionList')]
[CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('CA')]
        [PKI.CertificateServices.CertificateAuthority[]]$CertificationAuthority
    )
    process {
        foreach ($CA in $CertificationAuthority) {
            New-Object PKI.CertificateServices.PolicyModule.ExtensionList -ArgumentList $CA
        }
    }
}