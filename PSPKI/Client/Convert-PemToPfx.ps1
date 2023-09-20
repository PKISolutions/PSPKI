function Convert-PemToPfx {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('[System.Security.Cryptography.X509Certificates.X509Certificate2]')]
[CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [Alias('CertificatePath', 'CertPath')]
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
    if ($PSBoundParameters.Debug) {$DebugPreference = "continue"}
    $ErrorActionPreference = "Stop"

    # PSCore needs extra assembly import
    if ($PsIsCore) {
        Add-Type -AssemblyName "System.Security.Cryptography.X509Certificates"
    }

    # global variables
    $KeyStorageFlags = [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable
    if ($Install) {
        if ($StoreLocation -eq "CurrentUser") {
            $KeyStorageFlags = $KeyStorageFlags -bor [Security.Cryptography.X509Certificates.X509KeyStorageFlags]::UserKeySet
        } else {
            $KeyStorageFlags = $KeyStorageFlags -bor [Security.Cryptography.X509Certificates.X509KeyStorageFlags]::MachineKeySet
        }
    } else {
        $KeyStorageFlags = $KeyStorageFlags -bor [System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::EphemeralKeySet
    }
    $Cert = $null
    $AlgFamily = "RSA"
    $AsymmetricKey
    $Disposables = @()

    # returns: void
    function __extractCert([string]$Text) {
        if ($Text -match "(?msx).*-{5}BEGIN\sCERTIFICATE-{5}(.+)-{5}END\sCERTIFICATE-{5}") {
            $CertRawData = [Convert]::FromBase64String($matches[1])
            $Cert = New-Object Security.Cryptography.X509Certificates.X509Certificate2 -ArgumentList (,$CertRawData)
            switch ($Cert.PublicKey.Oid.Value) {
                $([SysadminsLV.PKI.Cryptography.AlgorithmOid]::RSA) { $AlgFamily = "RSA" }
                $([SysadminsLV.PKI.Cryptography.AlgorithmOid]::ECC) { $AlgFamily = "ECC" }
            }
        } else {
            throw "Missing certificate file."
        }
    }
    # returns: void
    function __extractPrivateKey([string]$Text) {
        $bin = if ($Text -match "(?msx).*-{5}BEGIN\sPRIVATE\sKEY-{5}(.+)-{5}END\sPRIVATE\sKEY-{5}") {
            [convert]::FromBase64String($matches[1])
        } elseif ($Text -match "(?msx).*-{5}BEGIN\sRSA\sPRIVATE\sKEY-{5}(.+)-{5}END\sRSA\sPRIVATE\sKEY-{5}") {
            [convert]::FromBase64String($matches[1])
        }  else {
            throw "The data is invalid."
        }
        if ($AlgFamily -eq "RSA") {
            # RSA can be in PKCS#1 format, which is not supported 
            $rsa = New-Object SysadminsLV.PKI.Cryptography.RsaPrivateKey (,$bin)
            $bin = $rsa.Export("Pkcs8")
            $rsa.Dispose()
        }

        $prov = [System.Security.Cryptography.CngProvider]::new($ProviderName)
        $blobType = [System.Security.Cryptography.CngKeyBlobFormat]::Pkcs8PrivateBlob
        # make it exportable
        $cngProp = New-Object System.Security.Cryptography.CngProperty("Export Policy", [BitConverter]::GetBytes(3), "None")
        $cng = [System.Security.Cryptography.CngKey]::Import($bin, $blobType, $prov)
        $Disposables += $cng
        $cng.SetProperty($cngProp)

        switch ($AlgFamily) {
            "RSA" {
                $AsymmetricKey = New-Object System.Security.Cryptography.RSACng $cng
            }
            "ECC" {
                $AsymmetricKey = New-Object System.Security.Cryptography.ECDsaCng $cng
                
            }
            default {
                throw "Specified algorithm is not supported"
            }
        }

        $Disposables += $AsymmetricKey
    }
    # returns: X509Certificate2 with associated private key
    function __associatePrivateKey() {
        switch ($AlgFamily) {
            "RSA" {[System.Security.Cryptography.X509Certificates.RSACertificateExtensions]::CopyWithPrivateKey($Cert, $AsymmetricKey)}
            "ECC" {[System.Security.Cryptography.X509Certificates.ECDsaCertificateExtensions]::CopyWithPrivateKey($Cert, $AsymmetricKey)}
        }
    }
    function __installCert($CertWithKey) {
        if (!$Install) {
            return
        }

        if ($Install) {
            $store = New-Object Security.Cryptography.X509Certificates.X509Store "my", $StoreLocation
            $store.Open("ReadWrite")
            $Disposables += $store
            $store.Add($CertWithKey)
            $store.Close()
        }
    }
    function __exportPfx($CertWithKey) {
        if ([string]::IsNullOrWhiteSpace($OutputPath)) {
            return
        }

        if (!$Password) {
            $Password = Read-Host -Prompt "Enter PFX password" -AsSecureString
        }
        $pfxBytes = $CertWithKey.Export("pfx", $Password)
        Export-Binary $OutputPath $pfxBytes
    }

    $File = Get-Item $InputPath -Force -ErrorAction Stop
    if ($KeyPath) {
        $Key = Get-Item $KeyPath -Force -ErrorAction Stop
    }
    
    # parse content
    $Text = Get-Content -Path $InputPath -Raw -ErrorAction Stop
    Write-Debug "Extracting certificate information..."
    __extractCert $Text
    if ($Key) {
        $Text = Get-Content -Path $KeyPath -Raw -ErrorAction Stop
    }
    __extractPrivateKey $Text

    $PfxCert = __associatePrivateKey
    __installCert $PfxCert
    __exportPfx $PfxCert
    # release unmanaged resources
    $Disposables | %{$_.Dispose()}

    $PfxCert
}