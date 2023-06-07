function Add-OnlineResponderArrayMember {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Management.CertificateServices.OcspResponder')]
[CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [SysadminsLV.PKI.Management.CertificateServices.OcspResponder]$ArrayController,
        [Parameter(Mandatory = $true)]
        [SysadminsLV.PKI.Management.CertificateServices.OcspResponder]$ArrayMember

    )

    $ArrayController.AddArrayMember($ArrayMember)
    $ArrayController
}