function Ping-ICertInterface {
<#
.ExternalHelp PSPKI.Help.xml
#>
[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias('CA')]
		[PKI.CertificateServices.CertificateAuthority[]]$CertificationAuthority
	)
	process {
		foreach ($CA in $CertificationAuthority) {
			$output = New-Object psobject -Property @{
				ConfigString = $CA.ConfigString
				ICertAdmin = $false
				ICertRequest = $false
			}
			try {
				$CertAdmin = New-Object -ComObject CertificateAuthority.Admin
				[Void]$CertAdmin.GetCAProperty($CA.ConfigString,0x6,0,4,0)
				$output.ICertAdmin = $true
			} catch {
				#
			} finally {[void][Runtime.InteropServices.Marshal]::ReleaseComObject($CertAdmin)}
			try {
				$CertRequest = New-Object -ComObject CertificateAuthority.Request
				[Void]$CertRequest.GetCAProperty($CA.ConfigString,0x6,0,4,0)
				$output.ICertRequest = $true
			} catch {
				#
			} finally {[void][Runtime.InteropServices.Marshal]::ReleaseComObject($CertRequest)}
			$output
		}
	}
}