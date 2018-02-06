function New-CertificateRequest {
<#
.ExternalHelp PSPKI.Help.xml
#>
[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, ParameterSetName = "default")]
		[string]$Subject,
		[Alias('CSP')]
		[string]$ProviderName = "Microsoft Software Key Storage Provider",
		[string]$AlgorithmName = "RSA",
		[int]$KeyLength = 2048,
		[validateSet("Exchange","Signature")]
		[string]$KeySpec = "Exchange",
		[Alias('EKU')]
		[Security.Cryptography.Oid[]]$EnhancedKeyUsage,
		[Alias('KU')]
		[Security.Cryptography.X509Certificates.X509KeyUsageFlags]$KeyUsage,
		[Alias('SAN')]
		[String[]]$SubjectAlternativeName,
		[bool]$IsCA,
		[int]$PathLength = -1,
		[Parameter(ParameterSetName = "__fromTemplate")]
		[string]$CertificateTemplate,
		[Parameter(ParameterSetName = "__fromCert")]
		[Security.Cryptography.X509Certificates.X509Certificate2]$ExistingCertificate,
		[Security.Cryptography.X509Certificates.X509ExtensionCollection]$CustomExtension,
		[ValidateSet('MD5','SHA1','SHA256','SHA384','SHA512')]
		[string]$SignatureAlgorithm = "SHA256",
		[Security.Cryptography.X509Certificates.X509Certificate2Collection]$ExternalSigner,
		[string]$FriendlyName,
		[Security.Cryptography.X509Certificates.StoreLocation]$StoreLocation = "LocalMachine",
		[ValidateSet('PKCS10', 'PKCS7', 'CMC')]
		[string]$RequestType = "PKCS10",
		[Alias('OutFile','OutPath','Out')]
		[IO.FileInfo]$Path,
		[Security.SecureString]$Password,
		[switch]$AllowSMIME,
		[switch]$Exportable,
		[Parameter(ParameterSetName = "__fromCert")]
		[switch]$ReuseKey
	)
	$ErrorActionPreference = "Stop"
	if ([Environment]::OSVersion.Version.Major -lt 6) {
		$NotSupported = New-Object NotSupportedException -ArgumentList "Windows XP and Windows Server 2003 are not supported!"
		throw $NotSupported
	}
	$ExtensionsToAdd = @()

#region constants
	# contexts
	New-Variable -Name UserContext -Value 0x1 -Option Constant
	New-Variable -Name MachineContext -Value 0x2 -Option Constant
	# encoding
	New-Variable -Name Base64Header -Value 0x0 -Option Constant
	New-Variable -Name Base64 -Value 0x1 -Option Constant
	New-Variable -Name Binary -Value 0x3 -Option Constant
	New-Variable -Name Base64RequestHeader -Value 0x4 -Option Constant
	# SANs
	New-Variable -Name OtherName -Value 0x1 -Option Constant
	New-Variable -Name RFC822Name -Value 0x2 -Option Constant
	New-Variable -Name DNSName -Value 0x3 -Option Constant
	New-Variable -Name DirectoryName -Value 0x5 -Option Constant
	New-Variable -Name URL -Value 0x7 -Option Constant
	New-Variable -Name IPAddress -Value 0x8 -Option Constant
	New-Variable -Name RegisteredID -Value 0x9 -Option Constant
	New-Variable -Name Guid -Value 0xa -Option Constant
	New-Variable -Name UPN -Value 0xb -Option Constant
	# installation options
	New-Variable -Name AllowNone -Value 0x0 -Option Constant
	New-Variable -Name AllowNoOutstandingRequest -Value 0x1 -Option Constant
	New-Variable -Name AllowUntrustedCertificate -Value 0x2 -Option Constant
	New-Variable -Name AllowUntrustedRoot -Value 0x4 -Option Constant
	# PFX export options
	New-Variable -Name PFXExportEEOnly -Value 0x0 -Option Constant
	New-Variable -Name PFXExportChainNoRoot -Value 0x1 -Option Constant
	New-Variable -Name PFXExportChainWithRoot -Value 0x2 -Option Constant
	# cert inheritance
	New-Variable -Name InheritNewDefaultKey -Value 0x1 -Option Constant
	New-Variable -Name InheritPrivateKey -Value 0x3 -Option Constant
#endregion

#region Extensions

#region Enhanced Key Usages processing
	if ($EnhancedKeyUsage) {
		$OIDs = New-Object -ComObject X509Enrollment.CObjectIDs
		$EnhancedKeyUsage | ForEach-Object {
			$OID = New-Object -ComObject X509Enrollment.CObjectID
			$OID.InitializeFromValue($_.Value)
			# http://msdn.microsoft.com/en-us/library/aa376785(VS.85).aspx
			$OIDs.Add($OID)
		}
		# http://msdn.microsoft.com/en-us/library/aa378132(VS.85).aspx
		$EKU = New-Object -ComObject X509Enrollment.CX509ExtensionEnhancedKeyUsage
		$EKU.InitializeEncode($OIDs)
		$ExtensionsToAdd += "EKU"
	}
#endregion

#region Key Usages processing
	if ($KeyUsage -ne $null) {
		$KU = New-Object -ComObject X509Enrollment.CX509ExtensionKeyUsage
		$KU.InitializeEncode([int]$KeyUsage)
		$KU.Critical = $true
		$ExtensionsToAdd += "KU"
	}
#endregion

#region Basic Constraints processing
	if ($PSBoundParameters.Keys.Contains("IsCA")) {
		# http://msdn.microsoft.com/en-us/library/aa378108(v=vs.85).aspx
		$BasicConstraints = New-Object -ComObject X509Enrollment.CX509ExtensionBasicConstraints
		if (!$IsCA) {$PathLength = -1}
		$BasicConstraints.InitializeEncode($IsCA,$PathLength)
		$BasicConstraints.Critical = $IsCA
		$ExtensionsToAdd += "BasicConstraints"
	}
#endregion

#region SAN processing
	if ($SubjectAlternativeName) {
		$SAN = New-Object -ComObject X509Enrollment.CX509ExtensionAlternativeNames
		$Names = New-Object -ComObject X509Enrollment.CAlternativeNames
		foreach ($altname in $SubjectAlternativeName) {
			$Name = New-Object -ComObject X509Enrollment.CAlternativeName
			switch -Regex ($altname) {
				"^dns:(.+)" {$Name.InitializeFromString($DNSName,$Matches[1])}
				"^email:(.+)" {$Name.InitializeFromString($RFC822Name,$Matches[1])}
				"^upn:(.+)" {$Name.InitializeFromString($UPN,$Matches[1])}
				"^ip:(.+)" {
					$Bytes = [Net.IPAddress]::Parse($Matches[1]).GetAddressBytes()
					$Name.InitializeFromRawData($IPAddress,$Base64,[Convert]::ToBase64String($Bytes))
				}
				"^dn:(.+)" {
					$Bytes = ([Security.Cryptography.X509Certificates.X500DistinguishedName]$Matches[1]).RawData
					$Name.InitializeFromRawData($DirectoryName,$Base64,[Convert]::ToBase64String($Bytes))
				}
				"^oid:(.+)" {$Name.InitializeFromString($RegisteredID,$Matches[1])}
				"^url:(.+)" {$Name.InitializeFromString($URL,$Matches[1])}
				"^guid:(.+)" {
					$Bytes = [Guid]::Parse($Matches[1]).ToByteArray()
					$Name.InitializeFromRawData($Guid,$Base64,[Convert]::ToBase64String($Bytes))
				}
				"other:(.+):(.+)" {
					$Name.InitializeFromOtherName($matches[1],$base64,$Matches[2],$false)
				}
			}
			$Names.Add($Name)
		}
		$SAN.InitializeEncode($Names)
		$ExtensionsToAdd += "SAN"
	}
#endregion

#region Custom Extensions
	if ($CustomExtension) {
		$count = 0
		foreach ($ext in $CustomExtension) {
			# http://msdn.microsoft.com/en-us/library/aa378077(v=vs.85).aspx
			$Extension = New-Object -ComObject X509Enrollment.CX509Extension
			$EOID = New-Object -ComObject X509Enrollment.CObjectId
			$EOID.InitializeFromValue($ext.Oid.Value)
			$EValue = [Convert]::ToBase64String($ext.RawData)
			$Extension.Initialize($EOID,$Base64,$EValue)
			$Extension.Critical = $ext.Critical
			New-Variable -Name ("ext" + $count) -Value $Extension
			$ExtensionsToAdd += ("ext" + $count)
			$count++
		}
	}
#endregion

#endregion

#region Private Key
	# http://msdn.microsoft.com/en-us/library/aa378921(VS.85).aspx
	$PrivateKey = New-Object -ComObject X509Enrollment.CX509PrivateKey
	$PrivateKey.ProviderName = $ProviderName
	$AlgID = New-Object -ComObject X509Enrollment.CObjectId
	$AlgID.InitializeFromValue(([Security.Cryptography.Oid]$AlgorithmName).Value)
	$PrivateKey.Algorithm = $AlgID
	# http://msdn.microsoft.com/en-us/library/aa379409(VS.85).aspx
	$PrivateKey.KeySpec = switch ($KeySpec) {"Exchange" {1}; "Signature" {2}}
	$PrivateKey.Length = $KeyLength
	# key will be stored in current user certificate store
	$PrivateKey.MachineContext = if ($StoreLocation -eq "LocalMachine") {$true} else {$false}
	$PrivateKey.ExportPolicy = if ($Exportable) {1} else {0}
	$PrivateKey.Create()
#endregion

#region request template
	$RequestTemplate = New-Object -ComObject X509Enrollment.CX509CertificateRequestPkcs10
	$ctx = switch ($StoreLocation) {
		"CurrentUser" {1}
		"LocalMachine" {2}
	}
	switch ($PSCmdlet.ParameterSetName) {
		"__fromTemplate" {
			$RequestTemplate.InitializeFromTemplateName($ctx, $CertificateTemplate)
		}
		"__fromCert" {
			$inheritance = if ($ReuseKey) {$InheritPrivateKey} else {$InheritNewDefaultKey}
			$Base64Cert = [Convert]::ToBase64String($ExistingCertificate.RawData)
			$RequestTemplate.InitializeFromCertificate($ctx, $Base64Cert, $Base64, $inheritance)
		}
		default {
			$RequestTemplate.InitializeFromPrivateKey($ctx, $PrivateKey, "")
		}
	}
	if ($AllowSMIME) {$RequestTemplate.SmimeCapabilities = $true}
#endregion

#region Subject processing
	if (![string]::IsNullOrEmpty($Subject)) {
		# http://msdn.microsoft.com/en-us/library/aa377051(VS.85).aspx
		$SubjectDN = New-Object -ComObject X509Enrollment.CX500DistinguishedName
		$SubjectDN.Encode($Subject, 0x0)
		$RequestTemplate.Subject = $SubjectDN
	}
	if ($ExtensionsToAdd -gt 0) {
		$reqExts = $RequestTemplate.X509Extensions | % {$_.ObjectId.Value}
		$ExtensionsToAdd | % {
			$extValue = Get-Variable -Name $_-ValueOnly
			if (!($reqExts -contains $extValue.ObjectId.Value)) {
				$RequestTemplate.X509Extensions.Add($_)
			}
		}
	}
#endregion	
	
	# http://msdn.microsoft.com/en-us/library/aa377124(VS.85).aspx
	$Cert = New-Object -ComObject X509Enrollment.CX509CertificateRequestCertificate
	if ($PrivateKey.MachineContext) {
		$Cert.InitializeFromPrivateKey($MachineContext,$PrivateKey,"")
	} else {
		$Cert.InitializeFromPrivateKey($UserContext,$PrivateKey,"")
	}
	$Cert.Subject = $SubjectDN
	$Cert.Issuer = $Cert.Subject
	$Cert.NotBefore = $NotBefore
	$Cert.NotAfter = $NotAfter
	foreach ($item in $ExtensionsToAdd) {$Cert.X509Extensions.Add((Get-Variable -Name $item -ValueOnly))}
	if ($AllowSMIME) {$Cert.SmimeCapabilities = $true}
	$SigOID = New-Object -ComObject X509Enrollment.CObjectId
	$SigOID.InitializeFromValue(([Security.Cryptography.Oid]$SignatureAlgorithm).Value)
	$Cert.SignatureInformation.HashAlgorithm = $SigOID
	# completing certificate request template building
	$Cert.Encode()
	
	# interface: http://msdn.microsoft.com/en-us/library/aa377809(VS.85).aspx
	$Request = New-Object -ComObject X509Enrollment.CX509enrollment
	$Request.InitializeFromRequest($Cert)
	$Request.CertificateFriendlyName = $FriendlyName
	$endCert = $Request.CreateRequest($Base64)
	$Request.InstallResponse($AllowUntrustedCertificate,$endCert,$Base64,"")
	switch ($PSCmdlet.ParameterSetName) {
		'__file' {
			$PFXString = $Request.CreatePFX(
				[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)),
				$PFXExportEEOnly,
				$Base64
			)
			Set-Content -Path $Path -Value ([Convert]::FromBase64String($PFXString)) -Encoding Byte
		}
	}
}