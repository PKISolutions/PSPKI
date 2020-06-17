function Remove-OnlineResponderRevocationConfiguration {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Management.CertificateServices.OcspResponderRevocationConfiguration[]')]
[CmdletBinding(DefaultParameterSetName = '__config')]
	param (
		[Parameter(Mandatory = $true, ParameterSetName = '__config', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[SysadminsLV.PKI.Management.CertificateServices.OcspResponder[]]$RevocationConfiguration,
		[Parameter(Mandatory = $true, ParameterSetName = '__name', ValueFromPipelineByPropertyName = $true)]
		[string[]]$Name
	)

	process {
		foreach ($RevConfig in $RevocationConfiguration) {
			$OnlineResponder = Connect-OnlineResponder $RevConfig.ComputerName
			switch ($PSCmdlet.ParameterSetName) {
				'__config' {$OnlineResponder.RemoveRevocationConfiguration($RevConfig)}
				'__name' {$OnlineResponder.RemoveRevocationConfiguration($Name)}
			}
						
			$RevConfig
		}
	}
}