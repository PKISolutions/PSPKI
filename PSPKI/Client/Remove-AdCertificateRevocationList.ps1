function Remove-AdCertificateRevocationList {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('[SysadminsLV.PKI.Management.ActiveDirectory.DsCDPContainer]')]
[CmdletBinding(DefaultParameterSetName = '__crl')]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [SysadminsLV.PKI.Management.ActiveDirectory.DsCDPContainer]$CdpContainer,
        [Parameter(ParameterSetName = '__thumbprint', Mandatory = $true)]
        [String[]]$Thumbprint,
        [Parameter(ParameterSetName = '__crl', Mandatory = $true)]
        [Alias('CRL')]
        [SysadminsLV.PKI.Management.ActiveDirectory.DsCrlEntry[]]$CertificateRevocationList,
        [switch]$ForceDelete,
        [switch]$Dispose
    )
    switch ($PSCmdlet.ParameterSetName) {
        '__thumbprint' {
            for ($i = 0; $i -lt $Thumbprint.Length; $i++) {
                $Thumbprint[$i] = $Thumbprint[$i].Trim().Replace(" ", $null).ToUpper()
            }
            $crlsToRemove = $CdpContainer.RevocationLists | ?{$_.CRL.Thumbprint -in $Thumbprint}
            $crlsToRemove | ForEach-Object {
                [void]$CdpContainer.RemoveCrl($_)
            }
        }
        '__crl' {
            $CertificateRevocationList | ForEach-Object {
                [void]$CdpContainer.RemoveCrl($_)
            }
        }
    }
    $CdpContainer.SaveChanges($ForceDelete)
    if ($Dispose) {
        $CdpContainer.Dispose()
    }
    $CdpContainer
}