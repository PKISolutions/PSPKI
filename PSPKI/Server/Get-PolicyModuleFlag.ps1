function Get-PolicyModuleFlag {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('PKI.CertificateServices.PolicyModule.EditFlag')]
[CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('CA')]
        [PKI.CertificateServices.CertificateAuthority[]]$CertificationAuthority
    )
    process {
        foreach ($CA in $CertificationAuthority) {
            New-Object PKI.CertificateServices.PolicyModule.EditFlag -ArgumentList $CA
        }
    }
}