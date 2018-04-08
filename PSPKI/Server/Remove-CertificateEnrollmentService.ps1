function Remove-CertificateEnrollmentService {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Utils.ServiceOperationResult')]
[CmdletBinding()]
	param (
		[string]$CAConfig,
		[ValidateSet("UsrPwd", "Kerberos", "Certificate")]
		[string]$Authentication = "Kerberos",
		[switch]$Force
	)
	if ($Host.Name -eq "ServerRemoteHost") {throw New-Object NotSupportedException}
#region Check operating system
	if ($OSVersion.Major -ne 6 -and $OSVersion.Minor -ne 1) {
		New-Object SysadminsLV.PKI.Utils.ServiceOperationResult 0x80070057, "Only Windows Server 2008 R2 operating system is supported."
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
		New-Object SysadminsLV.PKI.Utils.ServiceOperationResult 0x80070005, "You must be logged on with Enterprise Admins permissions."
		return
	}
#endregion

	$auth = @{"Kerberos" = 2; "UsrPwd" = 4; "Certificate" = 8}
	if ($CAConfig -eq "" -and !$Force) {
		$config = New-Object -ComObject CertificateAuthority.Config
		try {
			$bstr = $config.GetConfig(1)
		} catch {
			New-Object SysadminsLV.PKI.Utils.ServiceOperationResult 0x80070002,
				"There is no available Enterprise Certification Authorities or user canceled operation."
			return
		}
	} elseif ($CAConfig -ne "" -and !$Force) {
		$bstr = $CAConfig
	} else {
		$bstr = $null
		$auth.$Authentication = $null
	}
	$CES = New-Object -ComObject CERTOCM.CertificateEnrollmentServerSetup
	Write-Verbose @"
Performing Certificate Enrollment Service removal with the fillowing settings:
CA configuration string : $(if ($bstr -eq $null) {"Any"} else {$bstr})
Authentication          : $(if ($auth.$Authentication -eq $null) {"Any"} else {$Authentication})
Remove packages         : $(if ($Force) {"Yes"} else {"No"})
"@
	try {
		$CES.Uninstall($bstr, $auth.$Authentication)
		New-Object SysadminsLV.PKI.Utils.ServiceOperationResult 0
	} catch {
		New-Object SysadminsLV.PKI.Utils.ServiceOperationResult $_.Exception.HResult
		return
	}
	if ($Force) {
		Import-Module ServerManager
		Remove-WindowsFeature -Name ADCS-Enroll-Web-Svc | Out-Null
	}
}