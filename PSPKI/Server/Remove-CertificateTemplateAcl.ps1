function Remove-CertificateTemplateAcl {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('PKI.Security.SecurityDescriptor[]')]
[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
		[Alias('AclObject','Acl')]
		[PKI.Security.SecurityDescriptor2[]]$InputObject,
		[Security.Principal.NTAccount[]]$User,
		[Security.AccessControl.AccessControlType]$AccessType = "Allow"
	)
	begin {
		if ($PSBoundParameters.Verbose) {$VerbosePreference = "Contine"}
		if ($PSBoundParameters.Debug) {$DebugPreference = "Continue"}
	}
	process {
		foreach ($Acl in $InputObject) {
			foreach ($u in $User) {
				Write-Verbose "processing user: '$u'"
				Write-Verbose "Check whether the user account is valid"
				try {$SID = ((New-Object Security.Principal.NTAccount $u).Translate([Security.Principal.SecurityIdentifier])).Value}
				catch {
					Write-Error -Category ObjectNotFound -ErrorId "ObjectNotFoundException" `
					-Message "The user account '$u' is not valid"
					return
				}
				$u = ((New-Object Security.Principal.SecurityIdentifier $SID).Translate([Security.Principal.NTAccount])).Value
				Write-Debug "User's '$u' account SID '$SID'"
				$Acl.Access = $Acl.Access | Where-Object {$_.IdentityReference -ne $u -and $_.AccessType -eq $AccessType}
			}
			$Acl
		}
	}
}