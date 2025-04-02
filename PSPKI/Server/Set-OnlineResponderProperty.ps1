function Set-OnlineResponderProperty {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Management.CertificateServices.OcspResponder')]
[CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [SysadminsLV.PKI.Management.CertificateServices.OcspResponder[]]$OnlineResponder,
        [int]$MaxRequestEntryCount,
        [int]$MaxCacheEntryCount,
        [int]$ThreadCount,
        [int]$MaxRequestSize,
        [SysadminsLV.PKI.Management.CertificateServices.OcspResponderRequestFlags]$RequestFlag,
        [SysadminsLV.PKI.Management.CertificateServices.OcspResponderAuditFilter]$AuditFlag,
        [SysadminsLV.PKI.Management.CertificateServices.OcspResponderLogLevel]$LogLevel,
        [switch]$TraceDebug,
        [switch]$MakeArrayController
    )
    begin {
        Assert-CommandRequirement $PREREQ_RSAT -ErrorAction Stop
    }

    process {
        foreach ($Responder in $OnlineResponder) {
            $PSBoundParameters.Keys | ForEach-Object {
                switch ($_) {
                    "MaxRequestEntryCount" {$Responder.MaxNumOfRequestEntries = $MaxRequestEntryCount}
                    "MaxCacheEntryCount"   {$Responder.MaxNumOfCacheEntries = $MaxCacheEntryCount}
                    "ThreadCount"          {$Responder.NumOfThreads = $ThreadCount}
                    "MaxRequestSize"       {$Responder.MaxRequestSize = $MaxRequestSize}
                    "RequestFlag"          {$Responder.RequestFlags = $RequestFlag}
                    "AuditFlag"            {$Responder.AuditFilter = $AuditFlag}
                    "LogLevel"             {$Responder.LogLevel = $LogLevel}
                    "TraceDebug"           {$Responder.TraceDebugEnabled = $TraceDebug}
                    "MakeArrayController"  {if ($MakeArrayController)  {$Responder.MakeArrayController()}}
                }
            }

            $Responder
        }
    }
}