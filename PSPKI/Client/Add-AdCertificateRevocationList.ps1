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
        [SysadminsLV.PKI.Cryptography.X509Certificates.X509CRL2]$CertificateRevocationList,
        [string]$HostName,        
        [switch]$Dispose
    )
    Assert-CommandRequirement $PREREQ_ADDS -ErrorAction Stop

    $CdpContainer.AddCrl($CertificateRevocationList, $HostName)
    $CdpContainer.SaveChanges($false)
    if ($Dispose) {
        $CdpContainer.Dispose()
    }
    $CdpContainer
}