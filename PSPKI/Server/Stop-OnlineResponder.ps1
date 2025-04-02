function Stop-OnlineResponder {
<#
.ExternalHelp PSPKI.Help.xml
#>
[CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [SysadminsLV.PKI.Management.CertificateServices.OcspResponder[]]$OnlineResponder
    )
    begin {
        Assert-CommandRequirement $PREREQ_RSAT -ErrorAction Stop
    }

    process {
        foreach ($OCSP in $OnlineResponder) {
            $OCSP.Stop()
        }
    }
}