function Set-OnlineResponderAcl {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Security.AccessControl.OcspResponderSecurityDescriptor[]')]
[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias('ACL')]
		[SysadminsLV.PKI.Security.AccessControl.OcspResponderSecurityDescriptor[]]$InputObject,
		[switch]$RestartCA
	)
	process {
		foreach($ACL in $InputObject) {
			$ACL.SetObjectSecurity($RestartCA)
		}
	}
}