function Remove-DatabaseRow {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Utils.IServiceOperationResult')]
[CmdletBinding(DefaultParameterSetName = '__single')]
	param(
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			ParameterSetName = '__single'
		)]
		[ValidateScript({
			if ($_.GetType().FullName -eq "PKI.CertificateServices.DB.RequestRow") {$true} else {$false}
		})]$Request,
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
			ParameterSetName = '__bulk')]
		[Alias('CA')]
		[PKI.CertificateServices.CertificateAuthority[]]$CertificationAuthority,
		[Parameter(ParameterSetName = '__bulk')]
		[ValidateSet('ExpiredCerts','ExpiredFailedPending','Request','CRL')]
		[string]$Filter,
		[Parameter(Mandatory = $true, ParameterSetName = '__bulk')]
		[datetime]$RemoveBefore
	)
	begin {		
		$dwFlags = switch ($Filter) {
			"ExpiredCerts" {1}
			"ExpiredFailedPending" {2}
			default {0}
		}
		$Table = 0
		if ($Filter -eq 'CRL') {
			$dwFlags = 1
			$Table = 0x5000
		}
	}
	process {
		switch ($PsCmdlet.ParameterSetName) {
			"__single" {
				foreach ($Req in $Request) {
					if ($Req.Table -ne "Request" -and $Req.Table -ne "CRL") {
						Write-Warning "Non-request or non-CRL table row removal is not supported. ID='$($Req.RowId)'"
						return
					}
					$CertAdmin = New-Object -ComObject CertificateAuthority.Admin
					$Return = $CertAdmin.DeleteRow($Req.ConfigString,$dwFlags,0,0,$Req.RowId)
					if ($Return -eq 1) {
						New-Object SysadminsLV.PKI.Utils.ServiceOperationResult 0,
							"Deleted request row with ID=$($Req.RequestID).",
							$Req.RequestID
					} else {
						New-Object SysadminsLV.PKI.Utils.ServiceOperationResult 0x80070002,
							"Database row with ID = $($Req.RequestID) does not exist.",
							$Req.RequestID
						Write-Warning "Database row with ID = $($Req.RequestID) does not exist."
					}
					[void][Runtime.InteropServices.Marshal]::ReleaseComObject($CertAdmin)
				}
			}
			"__bulk" {
				foreach ($CA in $CertificationAuthority) {
					$CertAdmin = New-Object -ComObject CertificateAuthority.Admin
					$Return = $CertAdmin.DeleteRow($CA.ConfigString,$dwFlags,$RemoveBefore.ToUniversalTime(),$Table,0)
					if ($Return -gt 0) {
						if ($Filter -eq "CRL") {
							New-Object SysadminsLV.PKI.Utils.ServiceOperationResult 0,
								"Deleted CRLs expired before '$RemoveBefore'."
						} else {
							New-Object SysadminsLV.PKI.Utils.ServiceOperationResult 0,
								"Deleted requests expired before '$RemoveBefore'."
						}
					} else {
						New-Object SysadminsLV.PKI.Utils.ServiceOperationResult 0, "No rows were deleted."
					}
					[void][Runtime.InteropServices.Marshal]::ReleaseComObject($CertAdmin)
				}
			}
		}		
	}	
}