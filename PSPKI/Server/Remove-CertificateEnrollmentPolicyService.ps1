function Remove-CertificateEnrollmentPolicyService {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('PKI.Utils.ServiceOperationResult')]
[CmdletBinding()]
	param (
		[switch]$Force
	)
	if ($Host.Name -eq "ServerRemoteHost") {throw New-Object NotSupportedException}
#region Check operating system
	if ($OSVersion.Major -ne 6 -and $OSVersion.Minor -ne 1) {
		New-Object PKI.Utils.ServiceOperationResult 0x80070057, "Only Windows Server 2008 R2 operating system is supported."
		return
	}
#endregion

#region User permissions
# check if user has Enterprise Admins permissions
	$elevated = $false
	foreach ($sid in [Security.Principal.WindowsIdentity]::GetCurrent().Groups) {
	    if ($sid.Translate([Security.Principal.SecurityIdentifier]).IsWellKnown([Security.Principal.WellKnownSidType]::AccountEnterpriseAdminsSid)) {
	        $elevated = $true
    	}
	}
	if (!$elevated) {
		New-Object PKI.Utils.ServiceOperationResult 0x80070005, "You must be logged on with Enterprise Admins permissions."
		return
	}
#endregion

	$CEP = New-Object -ComObject CERTOCM.CertificateEnrollmentPolicyServerSetup
	Write-Verbose @"
Performing Certificate Enrollment Service removal with the fillowing settings:
Remove packages : $(if ($Force) {"Yes"} else {"No"})
"@
	try {
		$CEP.Uninstall()
		New-Object PKI.Utils.ServiceOperationResult 0
	} catch {
		New-Object PKI.Utils.ServiceOperationResult $_.Exception.HResult
		return
	}
	if ($Force) {
		Import-Module ServerManager
		Remove-WindowsFeature -Name ADCS-Enroll-Web-Pol | Out-Null
	}
}