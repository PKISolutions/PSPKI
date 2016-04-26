function Set-CertificateExtension {
<#
.ExternalHelp PSPKI.Help.xml
#>
[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidateScript({
			if ($_.GetType().FullName -eq "PKI.CertificateServices.DB.RequestRow") {$true} else {$false}
		})]$Request,
		[Parameter(Mandatory = $true)]
		[Object[]]$Extension,
		[switch]$Remove
	)
	process {
		foreach ($Req in $Request) {
			$CertAdmin = New-Object -ComObject CertificateAuthority.Admin
			if ($Extension[0] -is [Security.Cryptography.X509Certificates.X509ExtensionCollection] -and !$Remove) {
				foreach ($ext in $Extension[0]) {
					[Byte[]]$bytes = if ($ext.RawData % 2) {$ext.RawData + 0} else {$ext.RawData}
					$derValue = [Text.Encoding]::Unicode.GetString($bytes)
					try {
						$CertAdmin.SetCertificateExtension($Req.ConfigString,$Req.RequestID,$ext.Oid.Value,0x3,$ext.Critical,$derValue)
						if ([string]::IsNullOrEmpty($ext.Oid.FriendlyName)) {
							Write-Verbose "Extension OID='$($ext.Oid.Value)' was addedd to request ID='$($Req.RequestID)'."
						} else {
							Write-Verbose "Extension '$($ext.Oid.FriendlyName)' was addedd to request ID='$($Req.RequestID)'."
						}
					} catch {
						throw $_
					}
				}
			} elseif ($Extension[0] -is  [Security.Cryptography.X509Certificates.X509Extension] -and !$Remove) {
				foreach ($ext in $Extension) {
					$ext = [Security.Cryptography.X509Certificates.X509Extension]$ext
					[Byte[]]$bytes = if ($ext.RawData % 2) {$ext.RawData + 0} else {$ext.RawData}
					$derValue = [Text.Encoding]::Unicode.GetString($bytes)
					try {
						$CertAdmin.SetCertificateExtension($Req.ConfigString,$Req.RequestID,$ext.Oid.Value,0x3,$ext.Critical,$derValue)
						if ([string]::IsNullOrEmpty($ext.Oid.FriendlyName)) {
							Write-Verbose "Extension OID='$($ext.Oid.Value)' was addedd to request ID='$($Req.RequestID)'."
						} else {
							Write-Verbose "Extension '$($ext.Oid.FriendlyName)' was addedd to request ID='$($Req.RequestID)'."
						}
					} catch {
						throw $_
					}
				}
			} elseif ($Remove) {
				foreach ($ext in $Extension) {
					try {
						$oid = New-Object Security.Cryptography.Oid $ext
						[void][PKI.ASN.ASN1]::EncodeObjectIdentifier($ext)
						$CertAdmin.SetCertificateExtension($Req.ConfigString,$Req.RequestID,$oid.Value,0x1,0x2,0)
						Write-Verbose "Extension OID='$($oid.Value)' was removed from request ID='$($Req.RequestID)'."
					} catch {
						throw $_; return
					}
				}
			} else {
				throw New-Object ArgumentException "The parameter is invalid."
			}
			[void][Runtime.InteropServices.Marshal]::ReleaseComObject($CertAdmin)
			$Req
		}
	}	
}