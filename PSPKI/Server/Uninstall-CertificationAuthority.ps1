function Uninstall-CertificationAuthority {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('PKI.Utils.IServiceOperationResult')]
[CmdletBinding(
	ConfirmImpact = 'High',
	SupportsShouldProcess = $true
)]
	param(
		[switch]$AutoRestart,
		[switch]$Force
	)

#region OS and existing CA checking
	# check if script running on Windows Server 2008 or Windows Server 2008 R2
	$OS = Get-WmiObject Win32_OperatingSystem -Property ProductType
	if ($OSVersion.Major -lt 6) {
		Write-Error -Category NotImplemented -ErrorId "NotSupportedException" `
		-Message "Windows XP, Windows Server 2003 and Windows Server 2003 R2 are not supported!"
		return
	}
	$CertConfig = New-Object -ComObject CertificateAuthority.Config
    try {$ExistingDetected = $CertConfig.GetConfig(3)}
    catch {
		New-Object PKI.Utils.ServiceOperationResult 0x80070002,"Certificate Services are not installed on this computer."
        return
    }

#endregion

#region Binaries checking and removal stuff
	try {$CASetup = New-Object -ComObject CertOCM.CertSrvSetup.1}
	catch {
		Write-Error -Category NotImplemented -ErrorId "NotImplementedException" `
		-Message "Unable to load necessary interfaces. Your Windows Server operating system is not supported!"
		return
	}
	if ($OSVersion.Major -eq 6 -and $OSVersion.Minor -eq 0) {
		cmd /c "servermanagercmd -remove ADCS-Cert-Authority 2> null" | Out-Null
	} else {
		try {Import-Module ServerManager -ErrorAction Stop}
		catch {
			ocsetup 'ServerManager-PSH-Cmdlets' /quiet | Out-Null
			Start-Sleep 2
			Import-Module ServerManager
		}
		$status = (Get-WindowsFeature -Name ADCS-Cert-Authority).Installed
		if ($status) {
			$WarningPreference = "SilentlyContinue"
			if ($Force -or $PSCmdlet.ShouldProcess($env:COMPUTERNAME, "Uninstall Certification Authority")) {
				$CASetup.PreUninstall($false)
				$retn = Remove-WindowsFeature -Name ADCS-Cert-Authority -ErrorAction Stop
			}
		}
	}
	if ($AutoRestart) {
		Restart-Computer -Force
	} else {
		New-Object PKI.Utils.ServiceOperationResult 0,
			"Certification Authority role was removed successfully. You must restart this server to complete role removal."
	}
#endregion
}