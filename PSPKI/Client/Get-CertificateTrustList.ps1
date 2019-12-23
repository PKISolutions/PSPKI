function Get-CertificateTrustList {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Cryptography.X509Certificates.X509CertificateTrustList')]
[CmdletBinding(DefaultParameterSetName='__FileName')]
	param(
		[Parameter(ParameterSetName = "__FileName", Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
		[string]$Path,
		[Parameter(ParameterSetName = "__RawData", Mandatory = $true, Position = 0)]
		[Byte[]]$RawCTL
	)
	process {
		switch ($PsCmdlet.ParameterSetName) {
			"FileName" {
				if ($(Get-Item $Path -ErrorAction Stop).PSProvider.Name -ne "FileSystem") {
					throw {"File either does not exist or is not a file object"}
				}
				if ($(Get-Item $Path -ErrorAction Stop).Extension -ne ".stl") {
					throw {"File is not valid CTL file"}
				}
				New-Object SysadminsLV.PKI.Cryptography.X509Certificates.X509CertificateTrustList -ArgumentList $Path
			}
			"RawData" {New-Object SysadminsLV.PKI.Cryptography.X509Certificates.X509CertificateTrustList -ArgumentList @(,$RawCTL)}
		}
	}
}