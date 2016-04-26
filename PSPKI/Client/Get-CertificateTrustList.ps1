function Get-CertificateTrustList {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('System.Security.Cryptography.X509Certificates.X509CTL')]
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
				if ($(Get-Item $Path -ErrorAction Stop).Extension -ne ".crl") {
					throw {"File is not valid CTL file"}
				}
				New-Object Security.Cryptography.X509Certificates.X509CTL -ArgumentList $Path
			}
			"RawData" {New-Object Security.Cryptography.X509Certificates.X509CTL -ArgumentList @(,$RawCTL)}
		}
	}
}