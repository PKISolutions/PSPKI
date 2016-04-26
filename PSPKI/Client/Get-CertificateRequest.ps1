function Get-CertificateRequest {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('System.Security.Cryptography.X509CertificateRequests.X509CertificateRequest')]
[CmdletBinding(DefaultParameterSetName='FileName')]
	param(
		[Parameter(ParameterSetName = "FileName", Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
		[string]$Path,
		[Parameter(ParameterSetName = "RawData", Mandatory = $true, Position = 0)]
		[Byte[]]$RawRequest
	)
	
#region content parser
	switch ($PsCmdlet.ParameterSetName) {
		"FileName" {
			if ($(Get-Item $Path -ErrorAction Stop).PSProvider.Name -ne "FileSystem") {
				throw {"File either does not exist or not a file object"}
			}
			New-Object Security.Cryptography.X509CertificateRequests.X509CertificateRequest -ArgumentList $Path
		}
		"RawData" {New-Object Security.Cryptography.X509CertificateRequests.X509CertificateRequest -ArgumentList @(,$RawRequest)}
	}
#endregion
}