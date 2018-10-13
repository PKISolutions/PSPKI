function Get-IssuedRequest {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Management.CertificateServices.Database.AdcsDbRow[]')]
[CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('CA')]
        [PKI.CertificateServices.CertificateAuthority[]]$CertificationAuthority,
        [ValidateRange(2,2147483647)]
        [Alias('ID')]
        [int[]]$RequestID,
        [ValidateRange(1,2147483647)]
        [int]$Page = 1,
        [int]$PageSize = [int]::MaxValue,
        [Alias("Properties", "IncludeProperty", "IncludeProperties", "IncludedProperty", "IncludedProperties")]
        [String[]]$Property,
        [String[]]$Filter
    )
    Get-AdcsDatabaseRow `
        -CA $CertificationAuthority `
        -Table "Issued" `
        -RowId $RequestID `
        -Page $Page `
        -PageSize $PageSize `
        -Property $Property `
        -Filter $Filter
}