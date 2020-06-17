function Remove-OnlineResponderLocalCrlEntry {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Management.CertificateServices.OcspResponderRevocationConfiguration[]')]
[CmdletBinding(DefaultParameterSetName = '__serial')]
	param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[SysadminsLV.PKI.Management.CertificateServices.OcspResponderRevocationConfiguration[]]$InputObject,
		[Parameter(Mandatory = $true, ParameterSetName = '__serial')]
		[string[]]$SerialNumber,
		[Parameter(ParameterSetName = '__purge')]
		[switch]$Force
	)

	process {
		foreach ($RevConfig in $InputObject) {
			switch ($PSCmdlet.ParameterSetName) {
				'__serial' {
					$currentEntries = $RevConfig.LocalRevocationInformation
					$SerialNumber | ForEach-Object {
						$entry = $currentEntries[$_]
						if ($entry) {
							$currentEntries.Remove($entry)
						}
					}
					$RevConfig.LocalRevocationInformation = $currentEntries
				}
				'__purge' {$RevConfig.LocalRevocationInformation = $null}
			}
			
			$RevConfig.Commit()
			$RevConfig
		}
	}
}