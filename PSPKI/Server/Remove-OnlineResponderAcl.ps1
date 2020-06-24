function Remove-OnlineResponderAcl {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Security.AccessControl.OcspResponderSecurityDescriptor[]')]
[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias('AclObject','Acl')]
		[SysadminsLV.PKI.Security.AccessControl.OcspResponderSecurityDescriptor[]]$InputObject,
		[Security.Principal.NTAccount[]]$User,
		[Security.AccessControl.AccessControlType]$AccessType = "Allow"
	)
	process {
		foreach($ACL in $InputObject) {
			$User | ForEach-Object {
				[void]$ACL.PurgeAccessRules($_, $AccessType)
			}
			$ACL
		}
	}
}