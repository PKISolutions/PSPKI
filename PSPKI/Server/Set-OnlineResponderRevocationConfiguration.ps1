function Set-OnlineResponderRevocationConfiguration {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Management.CertificateServices.OcspResponderRevocationConfiguration')]
[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[SysadminsLV.PKI.Management.CertificateServices.OcspResponderRevocationConfiguration[]]$RevocationConfiguration,
		[Parameter(Mandatory = $true, ParameterSetName = '__dsEnroll')]
		[PKI.CertificateServices.CertificateAuthority]$SigningServer,
		[System.Security.Cryptography.X509Certificates.X509Certificate2]$SigningCertificate,
		[Parameter(Mandatory = $true, ParameterSetName = '__dsEnroll')]
		[string]$SigningCertTemplate,
		[System.Security.Cryptography.Oid2]$HashAlgorithm,
		[SysadminsLV.PKI.Management.CertificateServices.OcspSigningFlag]$SigningFlag,
		[int]$ReminderDuration,
		[string[]]$BaseCrlUrl,
		[string[]]$DeltaCrlUrl,
		[string[]]$SerialNumbersDirectory,
		[int]$CrlUrlTimeout,
		[int]$RefreshTimeout
	)

	process {
		foreach ($RevConfig in $RevocationConfiguration) {
			$PSBoundParameters.Keys | ForEach-Object {
				switch ($_) {
					"SigningServer"          {
						if (!$SigningServer.IsEnterprise) {
							throw new ArgumentException("Signing Server must be a valid Enterprise Certification Authority.")
						}
						$RevConfig.ConfigString = $SigningServer.ConfigString
					}
					"SigningCertificate"     {$RevConfig.SigningCertificate = $SigningCertificate}
					"SigningCertTemplate"    {$RevConfig.SigningCertificateTemplate = $SigningCertTemplate}
					"HashAlgorithm"          {$RevConfig.HashAlgorithm = $HashAlgorithm}
					"SigningFlag"            {$RevConfig.SigningFlags = $SigningFlag}
					"ReminderDuration"       {$RevConfig.ReminderDuration = $ReminderDuration}
					"BaseCrlUrl"             {$RevConfig.BaseCrlUrls = $BaseCrlUrl}
					"DeltaCrlUrl"            {$RevConfig.DeltaCrlUrls = $DeltaCrlUrl}
					"SerialNumbersDirectory" {$RevConfig.IssuedSerialNumbersDirectories = $SerialNumbersDirectory}
					"CrlUrlTimeout"          {$RevConfig.CrlUrlTimeout = $CrlUrlTimeout}
					"RefreshTimeout"         {$RevConfig.RefreshTimeout = $RefreshTimeout}
				}
			}

			$RevConfig.Commit()
			$RevConfig
		}
	}
}