function Get-ObjectIdentifierEx {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('Security.Cryptography.Oid2[]')]
[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true)]
		[string]$Value,
		[Security.Cryptography.OidGroupEnum]$Group,
		[switch]$UseActiveDirectory
	)
	if ($Group -eq $null) {
		[Security.Cryptography.Oid2]::GetAllOids($Value,$UseActiveDirectory)
	} else {
		New-Object Security.Cryptography.Oid2 -ArgumentList $Value, $Group, $UseActiveDirectory
	}
	
}