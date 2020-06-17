function Get-OnlineResponderRevocationConfiguration {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Management.CertificateServices.OcspResponderRevocationConfiguration[]')]
[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[SysadminsLV.PKI.Management.CertificateServices.OcspResponder[]]$OnlineResponder,
		[string]$Name
	)

	process {
		foreach ($Responder in $OnlineResponder) {
			if ([string]::IsNullOrEmpty($Name)) {
				$OnlineResponder.GetRevocationConfigurations()
			} else {
				$OnlineResponder.GetRevocationConfigurations() | Where-Object {$_.Name -like $Name}
			}
		}
	}
}