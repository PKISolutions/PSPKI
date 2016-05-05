function Get-CertificationAuthority {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('PKI.CertificateServices.CertificateAuthority[]')]
[CmdletBinding(DefaultParameterSetName = '__ComputerSet')]
	param(
		[Parameter(ParameterSetName = "__ComputerSet", Position = 0)]
		[string]$ComputerName = "*",
		[Parameter(ParameterSetName = "__NameSet", Position = 0)]
		[string]$Name = "*"
	)
	switch ($PsCmdlet.ParameterSetName) {
		"__ComputerSet" {[PKI.CertificateServices.CertificateAuthority]::EnumEnterpriseCAs("Server",$ComputerName)}
		"__NameSet" {[PKI.CertificateServices.CertificateAuthority]::EnumEnterpriseCAs("Name",$Name)}
	}
}