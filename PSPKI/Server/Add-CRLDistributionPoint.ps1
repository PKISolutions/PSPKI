function Add-CRLDistributionPoint {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('PKI.CertificateServices.CRLDistributionPoint')]
[CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [PKI.CertificateServices.CRLDistributionPoint[]]$InputObject,
        [Parameter(Mandatory = $true)]
        [String[]]$URI
    )
    process {
        foreach ($CDP in $InputObject) {
            try {
                $URIs = $CDP.URI | ForEach-Object {$_.reguri}
                foreach ($url in $URI) {
                    if ($URIs -notcontains $url) {$CDP.URI += New-Object PKI.CertificateServices.CDP $url}
                }
                $CDP
            } finally { }
        }
    }
}