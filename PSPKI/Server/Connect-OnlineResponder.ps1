function Connect-OnlineResponder {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Management.CertificateServices.OcspResponder')]
[CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [String]$ComputerName = [environment]::MachineName
    )

    Assert-CommandRequirement $PREREQ_RSAT -ErrorAction Stop

    [SysadminsLV.PKI.Management.CertificateServices.OcspResponder]::Connect($ComputerName)
}