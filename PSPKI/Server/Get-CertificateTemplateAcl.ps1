function Get-CertificateTemplateAcl {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('PKI.Security.SecurityDescriptor2[]')]
[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
		[PKI.CertificateTemplates.CertificateTemplate[]]$Template
	)
	process {
		foreach ($temp in $Template) {
			$adsi = [ADSI]("LDAP://" + $temp.DistinguishedName)
			$ACL = $adsi.ObjectSecurity
			$Users = $ACL.Access | ForEach-Object {$_.IdentityReference} | Select-Object -Unique
			$NewACL = @()
			foreach ($User in $Users) {
				foreach ($AccessType in "Allow", "Deny") {
					$Permission = @()
					$ACL.Access | Where-Object {$_.IdentityReference -eq $User -and $_.AccessControlType -eq $AccessType} | ForEach-Object {
						$Rights = @($_.ActiveDirectoryRights.tostring().split(",",[StringSplitOptions]::RemoveEmptyEntries) | ForEach-Object {$_.trim()})
						$GUID = $_.ObjectType.tostring()
						if ($Rights -contains "GenericRead" -or $Rights -contains "GenericExecute") {$Permission += "Read"}
						if ($Rights -contains "WriteDacl") {$Permission += "Write"}
						if ($Rights -contains "GenericAll") {$Permission += "FullControl"}
						if ($Rights -contains "ExtendedRight") {
							if ($GUID -eq "0e10c968-78fb-11d2-90d4-00c04f79dc55") {$Permission += "Enroll"}
							if ($GUID -eq "a05b8cc2-17bc-4802-a710-e7c15ab866a2") {$Permission += "Autoenroll"}
						}
					}
					if ($Permission) {
						$NewACL += New-Object PKI.Security.AccessControlEntry2 -Property @{
							IdentityReference = $User.Value
							AccessType = $AccessType;
							Permissions = $Permission
						}
					}
				}
			}
			New-Object PKI.Security.SecurityDescriptor2 -Property @{
				Path = $temp.DistinguishedName;
				Owner = $ACL.Owner;
				Access = $NewACL
			}
		}
	}
}