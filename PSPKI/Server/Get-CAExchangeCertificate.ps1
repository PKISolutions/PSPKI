function Get-CAExchangeCertificate {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType(
	'System.String[]',
	'System.Byte[]',
	'System.Security.Cryptography.X509Certificates.X509Certificate2[]'
)]
[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias('CA')]
		[PKI.CertificateServices.CertificateAuthority[]]$CertificationAuthority,
		[Security.Cryptography.X509Certificates.X509EncodingType]$Encoding = "Base64Header",
		[switch]$X509
	)
	process {
		foreach ($CA in $CertificationAuthority) {
			$xchg = $CA.GetCAExchangeCertificate()
			if ($X509) {return $xchg}
			switch ($Encoding) {
				"Base64Header" {[PKI.ManagedAPI.Crypt32Managed]::CryptBinaryToString($cert.RawData,"CRYPT_STRING_BASE64HEADER",0)}
				"Base64" {[PKI.ManagedAPI.Crypt32Managed]::CryptBinaryToString($cert.RawData,"CRYPT_STRING_BASE64",0)}
				"Binary" {$xchg.RawData}
				default {Write-Error "Specified encoding type is not supported."; return}
			}
		}
	}
}