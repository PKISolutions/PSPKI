function Unregister-ObjectIdentifier {
<#
.ExternalHelp PSPKI.Help.xml
#>
[CmdletBinding(
	ConfirmImpact = 'High',
	SupportsShouldProcess = $true
)]
	param(
		[Parameter(Mandatory = $true, ValueFrompipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[Security.Cryptography.Oid2]$Value,
		[switch]$UseActiveDirectory,
		[switch]$Force
	)
	if ($Force -or $PSCmdlet.ShouldProcess(
		$Env:COMPUTERNAME,
		"Unregister object identifier with name: '$($Value.FriendlyName)' and value: '$($Value.Value)'"
	)) {
		$retValue = [Security.Cryptography.Oid2]::Unregister($Value.Value,$Value.OidGroup,$UseActiveDirectory)
		if (!$retValue) {Write-Error "An error occured while attempting to unregister specified object identifier"}
	}
}