function Remove-CertificateEnrollmentService {
<#
.ExternalHelp PSPKI.Help.xml
#>
[CmdletBinding()]
	param (
		[string]$CAConfig,
		[ValidateSet("UsrPwd", "Kerberos", "Certificate")]
		[string]$Authentication = "Kerberos",
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

	$auth = @{"Kerberos" = 2; "UsrPwd" = 4; "Certificate" = 8}
	if ($CAConfig -eq "" -and !$Force) {
		$config = New-Object -ComObject CertificateAuthority.Config
		try {
			$bstr = $config.GetConfig(1)
		} catch {Write-Warning "There is no available Enterprise Certification Authorities or user canceled operation."; return}
	}
	elseif ($CAConfig -ne "" -and !$Force){$bstr = $CAConfig}
	else {$bstr = $null; $auth.$Authentication = $null}
	$CES = New-Object -ComObject CERTOCM.CertificateEnrollmentServerSetup
	Write-Host "Performing Certificate Enrollment Service removal with the fillowing settings:" -ForegroundColor Cyan
	if ($bstr -eq $null) {Write-Host "CA configuration string: Any" -ForegroundColor Cyan}
	else {Write-Host "CA configuration string: $bstr" -ForegroundColor Cyan}
	if ($auth.$Authentication -eq $null) {Write-Host "Authentication type: Any" -ForegroundColor Cyan}
	else {Write-Host "Authentication type: $Authentication" -ForegroundColor Cyan}
	if ($Force) {Write-Host "Remove installation packages: Yes" -ForegroundColor Cyan}
	else {write-Host "Remove installation packages: No" -ForegroundColor Cyan}
	Write-Host ("-" * 50) `
	`nRemoval results `
	`n("-" * 50) -ForegroundColor Green
	try {$CES.Uninstall($bstr, $auth.$Authentication)}
	catch {Write-Warning "CES service removal failed!"; $Error[0].Exception; return}
	Write-Host "CES service successfully removed!" -ForegroundColor Green
	if ($Force) {
		Import-Module ServerManager
		$retn = Remove-WindowsFeature -Name ADCS-Enroll-Web-Svc
		if (!$retn.Success) {
			Write-Warning "CES installation package removal failed due of the following error:"
			Write-Warning $retn.ExitCode
		}
		else {Write-Host "CES installation packages are successfully removed!" -ForegroundColor Green}
	}
}