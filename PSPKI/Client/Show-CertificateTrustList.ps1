function Show-CertificateTrustList {
<#
.ExternalHelp PSPKI.Help.xml
#>
[CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [SysadminsLV.PKI.Cryptography.X509Certificates.X509CertificateTrustList]$CTL
    )
    
    process {
        [SysadminsLV.PKI.Cryptography.X509Certificates.X509CertificateTrustListExtensions]::ShowUI($CTL)
    }
}