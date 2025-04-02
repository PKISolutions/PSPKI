function Remove-OnlineResponderRevocationConfiguration {
<#
.ExternalHelp PSPKI.Help.xml
#>
[CmdletBinding(DefaultParameterSetName = '__config')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = '__config', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [SysadminsLV.PKI.Management.CertificateServices.OcspResponderRevocationConfiguration[]]$RevocationConfiguration,
        [Parameter(Mandatory = $true, ParameterSetName = '__name', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [SysadminsLV.PKI.Management.CertificateServices.OcspResponder[]]$OnlineResponder,
        [Parameter(Mandatory = $true, ParameterSetName = '__name')]
        [string[]]$Name
    )
    begin {
        Assert-CommandRequirement $PREREQ_RSAT -ErrorAction Stop
    }

    process {
        switch ($PSCmdlet.ParameterSetName) {
            "__config" {
                $RevocationConfiguration | ForEach-Object {
                    $ocsp = Connect-OnlineResponder $_.ComputerName
                    $ocsp.RemoveRevocationConfiguration($_.Name)
                }
            }
            "__name" {
                foreach ($ocsp in $OnlineResponder) {
                    $Name | ForEach-Object {
                        $ocsp.RemoveRevocationConfiguration($_)
                    }
                }
            }
        }
    }
}