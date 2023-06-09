function Convert-PemToPfx {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('[System.Security.Cryptography.X509Certificates.X509Certificate2]')]
[CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$InputPath,
        [string]$KeyPath,
        [string]$OutputPath,
        [SysadminsLV.PKI.Cryptography.X509Certificates.X509KeySpecFlags]$KeySpec = "AT_KEYEXCHANGE",
        [Security.SecureString]$Password,
        [string]$ProviderName = "Microsoft Enhanced RSA and AES Cryptographic Provider",
        [Security.Cryptography.X509Certificates.StoreLocation]$StoreLocation = "CurrentUser",
        [switch]$Install
    )
    if ($PSBoundParameters.Verbose) {$VerbosePreference = "continue"}
    if ($PSBoundParameters.Debug) {
        $DebugPreference = "continue"
    }
    
    #region helper functions
    function __normalizeAsnInteger ($array) {
        $padding = $array.Length % 8
        if ($padding) {
            $array = $array[$padding..($array.Length - 1)]
        }
        [array]::Reverse($array)
        [Byte[]]$array
    }
    function __extractCert([string]$Text) {
        if ($Text -match "(?msx).*-{5}BEGIN\sCERTIFICATE-{5}(.+)-{5}END\sCERTIFICATE-{5}") {
        $keyFlags = [Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable
        if ($Install) {
            $keyFlags += if ($StoreLocation -eq "CurrentUser") {
                [Security.Cryptography.X509Certificates.X509KeyStorageFlags]::UserKeySet
            } else {
                [Security.Cryptography.X509Certificates.X509KeyStorageFlags]::MachineKeySet
            }
        }
        $RawData = [Convert]::FromBase64String($matches[1])
            try {
                New-Object Security.Cryptography.X509Certificates.X509Certificate2 -ArgumentList $RawData, "", $keyFlags
            } catch {throw "The data is not valid security certificate."}
            Write-Debug "X.509 certificate is correct."
        } else {throw "Missing certificate file."}
    }
    # returns [byte[]]
    function __composePRIVATEKEYBLOB($modulus, $PublicExponent, $PrivateExponent, $Prime1, $Prime2, $Exponent1, $Exponent2, $Coefficient) {
        Write-Debug "Calculating key length."
        $bitLen = "{0:X4}" -f $($modulus.Length * 8)
        Write-Debug "Key length is $($modulus.Length * 8) bits."
        [byte[]]$bitLen1 = Invoke-Expression 0x$([int]$bitLen.Substring(0,2))
        [byte[]]$bitLen2 = Invoke-Expression 0x$([int]$bitLen.Substring(2,2))
        [Byte[]]$PrivateKey = 0x07,0x02,0x00,0x00,0x00,0x24,0x00,0x00,0x52,0x53,0x41,0x32,0x00
        [Byte[]]$PrivateKey = $PrivateKey + $bitLen1 + $bitLen2 + $PublicExponent + ,0x00 + `
            $modulus + $Prime1 + $Prime2 + $Exponent1 + $Exponent2 + $Coefficient + $PrivateExponent
        $PrivateKey
    }
    # returns RSACryptoServiceProvider for dispose purposes
    function __attachPrivateKey([Byte[]]$PrivateKey) {
        $cspParams = New-Object Security.Cryptography.CspParameters -Property @{
            ProviderName = $ProviderName
            KeyContainerName = "pspki-" + [Guid]::NewGuid().ToString()
            KeyNumber = [int]$KeySpec
        }
        if ($Install -and $StoreLocation -eq "LocalMachine") {
            $cspParams.Flags += [Security.Cryptography.CspProviderFlags]::UseMachineKeyStore
        }
        $rsa = New-Object Security.Cryptography.RSACryptoServiceProvider $cspParams
        $rsa.ImportCspBlob($PrivateKey)
        if ($PSVersionTable.PSEdition -eq "Core") {
            Add-Type -AssemblyName "System.Security.Cryptography.X509Certificates"
            $script:Cert = [Security.Cryptography.X509Certificates.RSACertificateExtensions]::CopyWithPrivateKey($_Cert.RawData, $rsa)

        } else {
            $script:Cert.PrivateKey = $rsa
        }
        $rsa
    }
    # returns Asn1Reader
    function __decodePkcs1($base64) {
        Write-Debug "Processing PKCS#1 RSA KEY module."
        $asn = New-Object SysadminsLV.Asn1Parser.Asn1Reader @(,[Convert]::FromBase64String($base64))
        if ($asn.Tag -ne 48) {throw "The data is invalid."}
        $asn
    }
    # returns Asn1Reader
    function __decodePkcs8($base64) {
        Write-Debug "Processing PKCS#8 Private Key module."
        $asn = New-Object SysadminsLV.Asn1Parser.Asn1Reader @(,[Convert]::FromBase64String($base64))
        if ($asn.Tag -ne 48) {throw "The data is invalid."}
        # version
        if (!$asn.MoveNext()) {throw "The data is invalid."}
        # algorithm identifier
        if (!$asn.MoveNext()) {throw "The data is invalid."}
        # octet string
        if (!$asn.MoveNextCurrentLevel()) {throw "The data is invalid."}
        if ($asn.Tag -ne 4) {throw "The data is invalid."}
        if (!$asn.MoveNext()) {throw "The data is invalid."}
        $asn
    }
    #endregion
    $ErrorActionPreference = "Stop"
    
    $File = Get-Item $InputPath -Force -ErrorAction Stop
    if ($KeyPath) {$Key = Get-Item $KeyPath -Force -ErrorAction Stop}
    
    # parse content
    $Text = Get-Content -Path $InputPath -Raw -ErrorAction Stop
    Write-Debug "Extracting certificate information..."
    $Cert = __extractCert $Text
    if ($Key) {$Text = Get-Content -Path $KeyPath -Raw -ErrorAction Stop}
    $asn = if ($Text -match "(?msx).*-{5}BEGIN\sPRIVATE\sKEY-{5}(.+)-{5}END\sPRIVATE\sKEY-{5}") {
        __decodePkcs8 $matches[1]
    } elseif ($Text -match "(?msx).*-{5}BEGIN\sRSA\sPRIVATE\sKEY-{5}(.+)-{5}END\sRSA\sPRIVATE\sKEY-{5}") {
        __decodePkcs1 $matches[1]
    }  else {throw "The data is invalid."}
    # private key version
    if (!$asn.MoveNext()) {throw "The data is invalid."}
    # modulus n
    if (!$asn.MoveNext()) {throw "The data is invalid."}
    $modulus = __normalizeAsnInteger $asn.GetPayload()
    Write-Debug "Modulus length: $($modulus.Length)"
    # public exponent e
    if (!$asn.MoveNext()) {throw "The data is invalid."}
    # public exponent must be 4 bytes exactly.
    $PublicExponent = if ($asn.GetPayload().Length -eq 3) {
        ,0 + $asn.GetPayload()
    } else {
        $asn.GetPayload()
    }
    Write-Debug "PublicExponent length: $($PublicExponent.Length)"
    # private exponent d
    if (!$asn.MoveNext()) {throw "The data is invalid."}
    $PrivateExponent = __normalizeAsnInteger $asn.GetPayload()
    Write-Debug "PrivateExponent length: $($PrivateExponent.Length)"
    # prime1 p
    if (!$asn.MoveNext()) {throw "The data is invalid."}
    $Prime1 = __normalizeAsnInteger $asn.GetPayload()
    Write-Debug "Prime1 length: $($Prime1.Length)"
    # prime2 q
    if (!$asn.MoveNext()) {throw "The data is invalid."}
    $Prime2 = __normalizeAsnInteger $asn.GetPayload()
    Write-Debug "Prime2 length: $($Prime2.Length)"
    # exponent1 d mod (p-1)
    if (!$asn.MoveNext()) {throw "The data is invalid."}
    $Exponent1 = __normalizeAsnInteger $asn.GetPayload()
    Write-Debug "Exponent1 length: $($Exponent1.Length)"
    # exponent2 d mod (q-1)
    if (!$asn.MoveNext()) {throw "The data is invalid."}
    $Exponent2 = __normalizeAsnInteger $asn.GetPayload()
    Write-Debug "Exponent2 length: $($Exponent2.Length)"
    # coefficient (inverse of q) mod p
    if (!$asn.MoveNext()) {throw "The data is invalid."}
    $Coefficient = __normalizeAsnInteger $asn.GetPayload()
    Write-Debug "Coefficient length: $($Coefficient.Length)"
    # creating Private Key BLOB structure
    $PrivateKey = __composePRIVATEKEYBLOB $modulus $PublicExponent $PrivateExponent $Prime1 $Prime2 $Exponent1 $Exponent2 $Coefficient
    #region key attachment and export
    try {
        $rsaKey = __attachPrivateKey $PrivateKey
        if (![string]::IsNullOrEmpty($OutputPath)) {
            if (!$Password) {
                $Password = Read-Host -Prompt "Enter PFX password" -AsSecureString
            }
            $pfxBytes = $Cert.Export("pfx", $Password)
            if ($PsIsCore) {
                Set-Content -Path $OutputPath -Value $pfxBytes -AsByteStream
            } else {
                Set-Content -Path $OutputPath -Value $pfxBytes -Encoding Byte
            }
        }
        #endregion
        if ($Install) {
            $store = New-Object Security.Cryptography.X509Certificates.X509Store "my", $StoreLocation
            $store.Open("ReadWrite")
            $store.Add($Cert)
            $store.Close()
        }
    } finally {
        if ($rsaKey -ne $null) {
            $rsaKey.Dispose()
            $Cert
        }
    }
}