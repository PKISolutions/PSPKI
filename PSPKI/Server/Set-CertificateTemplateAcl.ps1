function Set-CertificateTemplateAcl {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('PKI.Security.SecurityDescriptor2[]')]
[CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [Alias('AclObject','Acl')]
        [PKI.Security.SecurityDescriptor2[]]$InputObject
    )
    process {
        foreach ($Acl in $InputObject) {
            $adsi = [ADSI]("LDAP://" + $Acl.Path)
            $adsi.ObjectSecurity.Access | ForEach-Object {$adsi.ObjectSecurity.PurgeAccessRules($_.IdentityReference)}
            foreach ($Entry in $Acl.Access) {
                switch -regex ($Entry.Permissions) {
                    "^FullControl&" {
                        $ACE = New-Object DirectoryServices.ActiveDirectoryAccessRule (
                            $Entry.IdentityReference,
                            "GenericAll",
                            $Entry.AccessType
                        )
                        $adsi.ObjectSecurity.AddAccessRule($ACE)
                        continue
                    }
                    "^Read$|^Write$" {
                        $Rights = if ($Entry.Permissions -contains "Read" -and $Entry.Permissions -contains "Write") {
                            "CreateChild","DeleteChild","Self","WriteProperty","DeleteTree","Delete","GenericRead","WriteDacl","WriteOwner"
                        } elseif ($Entry.Permissions -contains "Read") {
                            "GenericRead"
                        } elseif ($Entry.Permissions -contains "Write") {
                            "WriteProperty","WriteDacl","WriteOwner"
                        }
                        $ACE = New-Object DirectoryServices.ActiveDirectoryAccessRule (
                            $Entry.IdentityReference,
                            $Rights,
                            $Entry.AccessType
                        )
                        $adsi.ObjectSecurity.AddAccessRule($ACE)
                    }
                    "^Enroll$" {
                        $ACE = New-Object DirectoryServices.ActiveDirectoryAccessRule (
                            $Entry.IdentityReference,
                            "ExtendedRight",
                            $Entry.AccessType,
                            [Guid]"0e10c968-78fb-11d2-90d4-00c04f79dc55"
                        )
                        $adsi.ObjectSecurity.AddAccessRule($ACE)
                    }
                    "^Autoenroll$" {
                        $ACE = New-Object DirectoryServices.ActiveDirectoryAccessRule (
                            $Entry.IdentityReference,
                            "ExtendedRight",
                            $Entry.AccessType,
                            [Guid]"a05b8cc2-17bc-4802-a710-e7c15ab866a2"
                        )
                        $adsi.ObjectSecurity.AddAccessRule($ACE)
                    }
                }
            }
            try {
                $adsi.CommitChanges()
            } catch {Write-Error $_; return}
            $Acl
        }
    }
}