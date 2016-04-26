function Restore-CertificateRevocationListFlagDefault {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('PKI.CertificateServices.Flags.CRLFlag[]')]
[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[PKI.CertificateServices.Flags.CRLFlag[]]$InputObject,
		[switch]$RestartCA
	)
	process {
		foreach ($CRLFlag in $InputObject) {
			try {
				$CRLFlag.Restore()
				$Status = $CRLFlag.SetInfo($RestartCA)
				if ($Status) {
					if (!$RestartCA) {Write-Warning ($RestartRequired -f "Certificate Revocation List settings")}
				} else {Write-Warning $NothingIsSet}
				$CRLFlag
			} finally { }
		}
	}
}