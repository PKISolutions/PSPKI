function Remove-OnlineResponderRevocationConfiguration {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Management.CertificateServices.OcspResponder')]
[CmdletBinding(DefaultParameterSetName = '__config')]
	param (
		[Parameter(Mandatory = $true, ParameterSetName = '__config', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[SysadminsLV.PKI.Management.CertificateServices.OcspResponder[]]$OnlineResponder,
		[Parameter(Mandatory = $true, ParameterSetName = '__name', ValueFromPipelineByPropertyName = $true)]
		[string[]]$Name
	)

	process {
		$OnlineResponder | ForEach-Object {
			$RevConfigs = $OnlineResponder.GetRevocationConfigurations() | ForEach-Object {$_}
			foreach ($RevConfig in $RevConfigs) {
				switch ($PSCmdlet.ParameterSetName) {
					'__config' {$OnlineResponder.RemoveRevocationConfiguration($RevConfig)}
					'__name' {$OnlineResponder.RemoveRevocationConfiguration($Name)}
				}
			}

			$_
		}
	}
}