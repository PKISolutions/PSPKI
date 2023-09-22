function Remove-CertificatePrivateKey {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('System.Boolean')]
[Cmdletbinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('Cert')]
        [System.Security.Cryptography.X509Certificates.X509Certificate2[]]$Certificate
    )

    process {
        foreach ($c in $Certificate) {
            [SysadminsLV.PKI.Cryptography.X509Certificates.X509Certificate2ExtensionsWin]::DeletePrivateKey($c)
        }
    }
}