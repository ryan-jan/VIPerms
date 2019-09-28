function New-VIGlobalPermission {
    <#
    .SYNOPSIS
    Add a global permission for a user/group.
    
    .DESCRIPTION
    Creates a global permission assigning either a user or group to a specific role.
    
    .PARAMETER Name
    Specify the name of user or group including the domain.
    
    .PARAMETER IsGroup
    Specify whether the target is a group object or not.
    
    .PARAMETER RoleId
    Specify the identifier for the specific role to assign to the global permission.
    
    .PARAMETER Propagate
    Specify whether the permission should propagate to all children objects or not.
    
    .PARAMETER SkipCertificateCheck
    Skip certificate verification.
    
    .EXAMPLE
    New-VIGlobalPermission -Name "VSPHERE.LOCAL\joe-bloggs" -RoleId -1

    .EXAMPLE
    New-VIGlobalPermission -Name "VSPHERE.LOCAL\group-of-users" -IsGroup -RoleId -1

    .EXAMPLE
    New-VIGlobalPermission -Name "VSPHERE.LOCAL\joe-bloggs" -RoleId -1 -Propagate:$false
    #>


    param (
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [String] $Name,

        [Parameter(
            Position = 1,
            Mandatory = $false
        )]
        [Switch] $IsGroup,

        [Parameter(
            Position = 2,
            Mandatory = $false
        )]
        [String] $RoleId,

        [Parameter(
            Position = 3,
            Mandatory = $false
        )]
        [Switch] $Propagate = [Switch]::Present,

        [Parameter(
            Position = 4,
            Mandatory = $false
        )]
        [Switch] $SkipCertificateCheck
    )
    
    try {
        $ProPref = $ProgressPreference
        $ProgressPreference = "SilentlyContinue"
        if ($SkipCertificateCheck -or $Global:VIPerms.SkipCertificateCheck) {
            Set-CertPolicy -SkipCertificateCheck
        }
        Invoke-Login
        $Uri = ("https://$($Global:VIPerms.Server)/invsvc/mob3/?moid=authorizationService&" +
                "method=AuthorizationService.AddGlobalAccessControlList")
        $Group = switch ($IsGroup) {
            $true {"true"}
            $false {"false"}
        }
        $Prop = switch ($Propagate) {
            $true {"true"}
            $false {"false"}
        }
        $Body = ("vmware-session-nonce=$($Global:VIPerms.SessionNonce)&" +
                 "permissions=%3Cpermissions%3E%0D%0A+++%3Cprincipal%3E%0D%0A++++++" +
                 "%3Cname%3E$([Uri]::EscapeUriString($Name))%3C%2Fname%3E" +
                 "%0D%0A++++++%3Cgroup%3E$Group%3C%2Fgroup%3E%0D%0A+++%3C%2Fprincipal%3E%0D%0A+++" +
                 "%3Croles%3E$RoleId%3C%2Froles%3E%0D%0A+++" +
                 "%3Cpropagate%3E$Prop%3C%2Fpropagate%3E%0D%0A%3C%2Fpermissions%3E")
        $Params = @{
            Uri = $Uri
            WebSession = $Global:VIPerms.WebSession
            Method = "POST"
            Body = $Body
        }
        $Res = Invoke-WebRequest @Params
        Invoke-Logoff
        if ($SkipCertificateCheck -or $Global:VIPerms.SkipCertificateCheck) {
            Set-CertPolicy -ResetToDefault
        }
        $ProgressPreference = $ProPref
    } catch {
        $Err = $_
        throw $Err
    }
}