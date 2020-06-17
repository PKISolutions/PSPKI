function Add-OnlineResponderAcl {
<#
.ExternalHelp PSPKI.Help.xml
#>
[OutputType('SysadminsLV.PKI.Security.AccessControl.OcspResponderSecurityDescriptor[]')]
[CmdletBinding(DefaultParameterSetName = '__manual')]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelinebyPropertyName = $true)]
        [Alias('AclObject','Acl')]
        [SysadminsLV.PKI.Security.AccessControl.OcspResponderSecurityDescriptor[]]$InputObject,
        [Parameter(Mandatory = $true, ParameterSetName = '__ace')]
        [SysadminsLV.PKI.Security.AccessControl.OcspResponderAccessRule[]]$AcessRule,
        [Parameter(Mandatory = $true, ParameterSetName = '__manual')]
        [Security.Principal.NTAccount[]]$User,
        [Parameter(Mandatory = $true, ParameterSetName = '__manual')]
        [Security.AccessControl.AccessControlType]$AccessType,
        [Parameter(Mandatory = $true, ParameterSetName = '__manual')]
        [SysadminsLV.PKI.Security.AccessControl.OcspResponderRights]$AccessMask
    )
    begin {
        if ($PSBoundParameters.Verbose) {$VerbosePreference = "Contine"}
        if ($PSBoundParameters.Debug) {$DebugPreference = "Continue"}
    }
    process {
        foreach ($Acl in $InputObject) {
            switch ($PSCmdlet.ParameterSetName) {
                '__ace' {$AcessRule | ForEach-Object {[void]$Acl.AddAccessRule()}}
                '__manual' {
                    foreach ($u in $User) {
                        Write-Verbose "processing user: '$u'"
                        Write-Verbose "Check whether the user account is valid"
                        $SID = ((New-Object Security.Principal.NTAccount $u).Translate([Security.Principal.SecurityIdentifier])).Value
                        $u = ((New-Object Security.Principal.SecurityIdentifier $SID).Translate([Security.Principal.NTAccount])).Value
                        Write-Debug "User's '$u' account SID '$SID'"
                        Write-Debug "Creating new ACE for the user '$u', access type '$AccessType', access mask `'$($AccessMask -join ',')`'"
                        $ace = New-Object SysadminsLV.PKI.Security.AccessControl -ArgumentList $u, $AccessMask, $AccessType
                        $status = $Acl.AddAccessRule($ace)
                        Write-Verbose "Insert succeeded: $status"
                        Write-Debug "Insert succeeded: $status"
                    }
                }            
            }
            $Acl
        }
    }
}