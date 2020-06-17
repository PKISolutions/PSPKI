function Remove-OnlineResponderAcl {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Security.AccessControl.OcspResponderSecurityDescriptor[]')]
[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias('ACL')]
		[SysadminsLV.PKI.Security.AccessControl.OcspResponderSecurityDescriptor[]]$InputObject,
		[Security.Principal.NTAccount[]]$User
	)
	process {
		foreach($ACL in $InputObject) {
			$User | ForEach-Object {
				$ACL.PurgeAccessRules($_)
			}
			$ACL
		}
	}
}