function Show-CertificateRevocationList {
<#
.ExternalHelp PSPKI.Help.xml
#>
[CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [SysadminsLV.PKI.Cryptography.X509Certificates.X509CRL2]$CRL
    )
    
    process {
        [SysadminsLV.PKI.Cryptography.X509Certificates.X509CRL2Extensions]::ShowUI($CRL)
    }
}