function Add-OnlineResponderRevocationConfiguration {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Management.CertificateServices.OcspResponderRevocationConfiguration[]')]
[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[SysadminsLV.PKI.Management.CertificateServices.OcspResponder[]]$OnlineResponder,
		[Parameter(Mandatory = $true)]
		[string]$Name,
		[System.Security.Cryptography.X509Certificates.X509Certificate]$CaCertificate
	)

	process {
		foreach ($Responder in $OnlineResponder) {
			$OnlineResponder.AddRevocationConfiguration($Name, $CaCertificate)
		}
	}
}