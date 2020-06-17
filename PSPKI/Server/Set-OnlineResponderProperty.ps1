function Set-OnlineResponderProperty {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Management.CertificateServices.OcspResponder')]
[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
		[SysadminsLV.PKI.Management.CertificateServices.OcspResponder[]]$OnlineResponder,
		[int]$MaxRequestEntries,
		[int]$MaxCacheEntries,
		[int]$ThreadCount,
		[int]$MaxRequestSize,
		[SysadminsLV.PKI.Management.CertificateServices.OcspResponderRequestFlag]$RequestFlag,
		[SysadminsLV.PKI.Management.CertificateServices.OcspResponderAuditFilter]$AuditFlag,
		[SysadminsLV.PKI.Management.CertificateServices.OcspResponderLogLevel]$LogLevel,
		[switch]$TraceDebug,
		[switch]$MakeArrayController
	)

	process {
		foreach ($Responder in $OnlineResponder) {
			$PSBoundParameters.Keys | ForEach-Object {
				switch ($_) {
					"MaxRequestEntries"   {$Responder.MaxNumOfRequestEntries = $MaxRequestEntries}
					"MaxCacheEntries"     {$Responder.MaxNumOfCacheEntries = $MaxCacheEntries}
					"ThreadCount"         {$Responder.NumOfThreads = $ThreadCount}
					"MaxRequestSize"      {$Responder.MaxRequestSize = $MaxRequestSize}
					"RequestFlags"        {$Responder.RequestFlags = $RequestFlags}
					"AuditFlags"          {$Responder.AuditFilter = $AuditFlags}
					"LogLevel"            {$Responder.LogLevel = $LogLevel}
					"TraceDebug"          {$Responder.TraceDebugEnabled = $TraceDebug}
					"MakeArrayController" {if ($MakeArrayController)  {$Responder.MakeArrayController()}}
				}
			}
		}
	}
}