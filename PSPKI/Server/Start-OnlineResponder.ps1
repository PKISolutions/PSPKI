function Start-OnlineResponder {
<#
.ExternalHelp PSPKI.Help.xml
#>
[CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [SysadminsLV.PKI.Management.CertificateServices.OcspResponder[]]$OnlineResponder
    )
    process {
        foreach ($OCSP in $OnlineResponder) {
            $OCSP.Start()
        }
    }
}