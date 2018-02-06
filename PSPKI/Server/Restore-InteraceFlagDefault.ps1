function Restore-InterfaceFlagDefault {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('PKI.CertificateServices.Flags.InterfaceFlag[]')]
[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[PKI.CertificateServices.Flags.InterfaceFlag[]]$InputObject,
		[switch]$RestartCA
	)
	process {
		foreach ($InterfaceFlag in $InputObject) {
			try {
				$InterfaceFlag.Restore()
				$Status = $InterfaceFlag.SetInfo($RestartCA)
				if ($Status) {
					if (!$RestartCA) {Write-Verbose ($RestartRequired -f "management interface settings")}
				} else {Write-Verbose $NothingIsSet}
				$InterfaceFlag
			} finally { }
		}
	}
}