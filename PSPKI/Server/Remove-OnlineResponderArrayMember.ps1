function Remove-OnlineResponderArrayMember {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Management.CertificateServices.OcspResponder')]
[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[SysadminsLV.PKI.Management.CertificateServices.OcspResponder]$ArrayController,
		[Parameter(Mandatory = $true)]
		[String[]]$ComputerName
	)

	foreach ($comp in $ComputerName) {
		$ArrayController.RemoveArrayMember($comp)
	}
	$ArrayController
}