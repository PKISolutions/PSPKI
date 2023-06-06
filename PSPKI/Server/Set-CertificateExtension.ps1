function Set-CertificateExtension {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('PKI.Utils.IServiceOperationResult')]
[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[ValidateScript({
			if ($_.GetType().FullName -eq "SysadminsLV.PKI.Management.CertificateServices.Database.AdcsDbRow") {$true} else {$false}
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
					$derValue = [SysadminsLV.PKI.Utils.CryptographyUtils]::EncodeDerString($ext.RawData)
					try {
						$CertAdmin.SetCertificateExtension($Req.ConfigString,$Req.RequestID,$ext.Oid.Value,0x3,$ext.Critical,$derValue)
						New-Object SysadminsLV.PKI.Utils.ServiceOperationResult 0,
							"Extension '$([SysadminsLV.PKI.Utils.CLRExtensions.OidExtensions]::Format($ext.Oid, $true))' was addedd to request ID='$($Req.RequestID)'."
					} catch {
						throw $_
					}
				}
			} elseif ($Extension[0] -is  [Security.Cryptography.X509Certificates.X509Extension] -and !$Remove) {
				foreach ($ext in $Extension) {
					$ext = [Security.Cryptography.X509Certificates.X509Extension]$ext
					$derValue = [SysadminsLV.PKI.Utils.CryptographyUtils]::EncodeDerString($ext.RawData)
					try {
						$CertAdmin.SetCertificateExtension($Req.ConfigString,$Req.RequestID,$ext.Oid.Value,0x3,$ext.Critical,$derValue)
						New-Object SysadminsLV.PKI.Utils.ServiceOperationResult 0,
							"Extension '$([SysadminsLV.PKI.Utils.CLRExtensions.OidExtensions]::Format($ext.Oid, $true))' was addedd to request ID='$($Req.RequestID)'."
					} catch {
						throw $_
					}
				}
			} elseif ($Remove) {
				foreach ($ext in $Extension) {
					try {
						$oid = New-Object Security.Cryptography.Oid $ext
						[void][SysadminsLV.Asn1Parser.Asn1Utils]::EncodeObjectIdentifier($ext)
						$CertAdmin.SetCertificateExtension($Req.ConfigString,$Req.RequestID,$oid.Value,0x1,0x2,0)
						New-Object SysadminsLV.PKI.Utils.ServiceOperationResult 0,
							"Extension '$([SysadminsLV.PKI.Utils.CLRExtensions.OidExtensions]::Format($oid, $true))' was addedd to request ID='$($Req.RequestID)'."
						Write-Verbose "Extension OID='$($oid.Value)' was removed from request ID='$($Req.RequestID)'."
					} catch {
						throw $_
					}
				}
			} else {
				throw New-Object ArgumentException "The parameter is invalid."
			}
			[SysadminsLV.PKI.Utils.CryptographyUtils]::ReleaseCom($CertAdmin)
		}
	}	
}