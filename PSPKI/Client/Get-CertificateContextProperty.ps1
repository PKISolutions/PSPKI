function Get-CertificateContextProperty {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType()]
[CmdletBinding(DefaultParameterSetName = '__name')]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[Security.Cryptography.X509Certificates.X509Certificate2]$Certificate,
		[Parameter(ParameterSetName = '__name')]
		[Security.Cryptography.X509Certificates.X509CertificatePropertyType]$PropertyName = "None",
		[Parameter(ParameterSetName = '__list')]
		[switch]$NameList
	)
	process {
		foreach ($cert in $Certificate) {
			switch ($PSCmdlet.ParameterSetName) {
				"__name" {
					if ($PropertyName -eq "None") {
						[PKI.Utils.CLRExtensions.X509Certificate2Extensions]::GetCertificateContextProperties($cert)
					} else {
						[PKI.Utils.CLRExtensions.X509Certificate2Extensions]::GetCertificateContextProperty($cert, $PropertyName)
					}
				}
				"__list" {
					[PKI.Utils.CLRExtensions.X509Certificate2Extensions]::GetCertificateContextPropertyList($cert)
				}
			}
		}
	}
}