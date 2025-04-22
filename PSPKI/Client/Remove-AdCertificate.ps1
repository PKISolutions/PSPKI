function Remove-AdCertificate {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('[SysadminsLV.PKI.Management.ActiveDirectory.DsPkiContainer]')]
[CmdletBinding(DefaultParameterSetName = '__cert')]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [SysadminsLV.PKI.Management.ActiveDirectory.DsPkiCertContainer]$AdContainer,
        [Parameter(ParameterSetName = '__thumbprint', Mandatory = $true)]
        [String[]]$Thumbprint,
        [Parameter(ParameterSetName = '__cert', Mandatory = $true)]
        [SysadminsLV.PKI.Management.ActiveDirectory.DsCertificateEntry[]]$Certificate,
        [switch]$ForceDelete,
        [switch]$Dispose
    )
    switch ($PSCmdlet.ParameterSetName) {
        '__thumbprint' {
            for ($i = 0; $i -lt $Thumbprint.Length; $i++) {
                $Thumbprint[$i] = $Thumbprint[$i].Trim().Replace(" ", $null).ToUpper()
            }
            $certsToRemove = $AdContainer.Certificates | ?{$_.Certificate.Thumbprint -in $Thumbprint}
            $certsToRemove | ForEach-Object {
                [void]$AdContainer.RemoveCertificate($_)
            }
        }
        '__cert' {
            $Certificate | ForEach-Object {
                [void]$AdContainer.RemoveCertificate($_)
            }
        }
    }
    $AdContainer.SaveChanges($ForceDelete)
    if ($Dispose) {
        $AdContainer.Dispose()
    }
    $AdContainer
}