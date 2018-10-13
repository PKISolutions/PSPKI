function Add-AdCertificateRevocationList {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('[SysadminsLV.PKI.Management.ActiveDirectory.DsCDPContainer]')]
[CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [SysadminsLV.PKI.Management.ActiveDirectory.DsCDPContainer]$CdpContainer,
        [Parameter(Mandatory = $true)]
        [Alias('CRL')]
        [Security.Cryptography.X509Certificates.X509CRL2]$CertificateRevocationList,
        [string]$HostName,        
        [switch]$Dispose
    )
    $CdpContainer.AddCrl($CertificateRevocationList, $HostName)
    $CdpContainer.SaveChanges($false)
    if ($Dispose) {
        $CdpContainer.Dispose()
    }
    $CdpContainer
}