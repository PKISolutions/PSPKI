function Add-OnlineResponderLocalCrlEntry {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Management.CertificateServices.OcspResponderRevocationConfiguration')]
[CmdletBinding(DefaultParameterSetName = '__crlentry')]
	param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[SysadminsLV.PKI.Management.CertificateServices.OcspResponderRevocationConfiguration[]]$InputObject,
		[Parameter(Mandatory = $true, ParameterSetName = '__crlentry')]
		[System.Security.Cryptography.X509Certificates.X509CRLEntryCollection]$Entry,
		[Parameter(Mandatory = $true, ParameterSetName = '__serial')]
		[string[]]$SerialNumber,
		[Parameter(ParameterSetName = '__serial')]
		[System.Security.Cryptography.X509Certificates.X509RevocationReasons]$Reason = "Unspecified",
		[switch]$Force
	)

	process {
		foreach ($RevConfig in $InputObject) {
			switch ($PSCmdlet.ParameterSetName) {
				'__crlentry' {
					if ($Force) {
						$RevConfig.X509CRLEntryCollection = $Entry
					} elseif ($Entry -ne $null) {
						$currentEntries = $RevConfig.LocalRevocationInformation
						$currentEntries.AddRange($Entry)
					}
				}
				'__serial' {
					$entries = New-Object System.Security.Cryptography.X509Certificates.X509CRLEntryCollection
					$SerialNumber | ForEach-Object {
						$CRLEntry = New-Object System.Security.Cryptography.X509Certificates.X509CRLEntry -ArgumentList $_, $null, $Reason
						$entries.Add($CRLEntry)
					}
					$RevConfig.LocalRevocationInformation = $entries
				}
			}
			$RevConfig.Commit()
			$RevConfig
		}
	}
}