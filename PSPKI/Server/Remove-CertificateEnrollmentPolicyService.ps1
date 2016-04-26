function Remove-CertificateEnrollmentPolicyService {
<#
.ExternalHelp PSPKI.Help.xml
#>
[CmdletBinding()]
	param (
		[switch]$Force
	)

#region Check operating system
	$OS = (Get-WmiObject Win32_OperatingSystem).Caption
	if ($OS -notlike "Microsoft Windows Server 2008 R2*") {
		Write-Warning "Only Windows Server 2008 R2 operating system is supported!"; return
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
	if (!$elevated) {Write-Warning "You must be logged on with Enterprise Admins permissions!"; return}
#endregion

	$CEP = New-Object -ComObject CERTOCM.CertificateEnrollmentPolicyServerSetup
	Write-Host "Performing Certificate Enrollment Service removal with the fillowing settings:" -ForegroundColor Cyan
	if ($Force) {Write-Host "Remove installation packages: Yes" -ForegroundColor Cyan}
	else {write-Host "Remove installation packages: No" -ForegroundColor Cyan}
	Write-Host ("-" * 50) `
	`nRemoval results `
	`n("-" * 50) -ForegroundColor Green
	try {$CEP.Uninstall()}
	catch {Write-Warning "CEP service removal failed!"; $Error[0].Exception; return}
	Write-Host "CEP service successfully removed!" -ForegroundColor Green
	if ($Force) {
		Import-Module ServerManager
		$retn = Remove-WindowsFeature -Name ADCS-Enroll-Web-Pol
		if (!$retn.Success) {
			Write-Warning "CEP installation package removal failed due of the following error:"
			Write-Warning $retn.ExitCode
		}
		else {Write-Host "CEP installation packages are successfully removed!" -ForegroundColor Green}
	}
}