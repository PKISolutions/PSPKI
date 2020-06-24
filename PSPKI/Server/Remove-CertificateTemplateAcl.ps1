function Remove-CertificateTemplateAcl {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Security.AccessControl.CertTemplateSecurityDescriptor[]')]
[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
		[Alias('AclObject','Acl')]
		[SysadminsLV.PKI.Security.AccessControl.CertTemplateSecurityDescriptor[]]$InputObject,
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