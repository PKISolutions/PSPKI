function Get-CertificateTemplateAcl {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('PKI.Security.SecurityDescriptor2[]')]
[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
		[PKI.CertificateTemplates.CertificateTemplate[]]$Template
	)
	process {
		foreach ($t in $Template) {
			$t.GetSecurityDescriptor()
		}
	}
}