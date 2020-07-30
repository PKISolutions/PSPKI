function Add-OnlineResponderRevocationConfiguration {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Management.CertificateServices.OcspResponderRevocationConfiguration')]
[CmdletBinding(DefaultParameterSetName = '__cert')]
	param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[SysadminsLV.PKI.Management.CertificateServices.OcspResponder[]]$OnlineResponder,
		[Parameter(Mandatory = $true)]
		[string]$Name,
		[Parameter(Mandatory = $true, ParameterSetName = "__cert")]
		[System.Security.Cryptography.X509Certificates.X509Certificate]$CaCertificate,
		[Parameter(Mandatory = $true, ParameterSetName = "__ca")]
		[Alias('CA')]
		[PKI.CertificateServices.CertificateAuthority]$CertificationAuthority
	)

	process {
		foreach ($Responder in $OnlineResponder) {
			switch ($PSCmdlet.ParameterSetName) {
				"__cert" {$OnlineResponder.AddRevocationConfiguration($Name, $CaCertificate)}
				"__ca" {$OnlineResponder.AddRevocationConfiguration($Name, $CertificationAuthority)}
			}
		}
	}
}