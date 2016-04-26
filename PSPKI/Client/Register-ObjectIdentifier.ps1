function Register-ObjectIdentifier {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('System.Security.Cryptography.Oid2')]
[CmdletBinding(
	ConfirmImpact = 'High',
	SupportsShouldProcess = $true
)]
	param(
		[Parameter(Mandatory = $true)]
		[string]$FriendlyName,
		[Parameter(Mandatory = $true)]
		[string]$Value,
		[Parameter(Mandatory = $true)]
		[ValidateSet("ApplicationPolicy","IssuancePolicy")]
		[string]$OidGroup,
		[Uri]$CPSLocation,
		[Globalization.CultureInfo]$LocaleId,
		[switch]$UseActiveDirectory,
		[switch]$Force
	)
	#String value, String friendlyName, OidGroupEnum group, Boolean writeInDirectory, CultureInfo localeId, String cpsUrl = null
	$Group = switch ($OidGroup) {
		"ApplicationPolicy" {[Security.Cryptography.OidGroupEnum]::ApplicationPolicy}
		"IssuancePolicy" {[Security.Cryptography.OidGroupEnum]::IssuancePolicy}
	}
	if ($Force -or $PSCmdlet.ShouldProcess(
		$Env:COMPUTERNAME,
		"Register object identifier with name: '$FriendlyName' and value: '$Value'"
	)) {
		[Security.Cryptography.Oid2]::Register($Value,$FriendlyName,$Group,$UseActiveDirectory,$LocaleId,$CPSLocation)
	}
}