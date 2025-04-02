function Get-CATemplate {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('PKI.CertificateServices.CATemplate')]
[CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [Alias('CA')]
        [PKI.CertificateServices.CertificateAuthority[]]$CertificationAuthority
    )
    begin {
        Assert-CommandRequirement $PREREQ_ADDS -ErrorAction Stop
    }

    process {
        foreach ($CA in $CertificationAuthority) {
            New-Object PKI.CertificateServices.CATemplate -ArgumentList $CA
        }
    }
}