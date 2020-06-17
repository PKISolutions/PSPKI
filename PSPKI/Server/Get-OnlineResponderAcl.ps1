function Get-OnlineResponderAcl {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Security.AccessControl.OcspResponderSecurityDescriptor')]
[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[SysadminsLV.PKI.Management.CertificateServices.OcspResponder[]]$OnlineResponder
	)
	process {
		foreach($Responder in $OnlineResponder) {
			$Responder.GetSecurityDescriptor()
		}
	}
}