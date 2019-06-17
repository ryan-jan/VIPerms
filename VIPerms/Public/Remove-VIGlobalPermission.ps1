function Remove-VIGlobalPermission {
    <#
    .SYNOPSIS
    Delete a global permission for a specific user/group.
    
    .DESCRIPTION
    Delete a global permission for a specific user/group.
    
    .PARAMETER Name
    Specify the name of user or group including the domain.
    
    .PARAMETER IsGroup
    Specify whether the target is a group object or not.
    
    .PARAMETER SkipCertificateCheck
    Skip certificate verification.
    
    .EXAMPLE
    Remove-VIGlobalPermission -Name "VSPHERE.LOCAL\Administrator"

    .EXAMPLE
    Remove-VIGlobalPermission -Name "VSPHERE.LOCAL\group-of-users" -IsGroup
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
        [Switch] $SkipCertificateCheck
    )

    try {
        if ($SkipCertificateCheck) {
            Set-CertPolicy -SkipCertificateCheck
        }
        Invoke-Login
        $Uri = ("https://$($Global:VIPerms.Server)/invsvc/mob3/?moid=authorizationService&" +
                "method=AuthorizationService.RemoveGlobalAccess")
        $Group = switch ($IsGroup) {
            $true {"true"}
            $false {"false"}
        }
        $Body = ("vmware-session-nonce=$($Global:VIPerms.SessionNonce)&" +
                 "principals=%3Cprincipals%3E%0D%0A+++%3Cname%3E$([Uri]::EscapeUriString($Name))" +
                 "%3C%2Fname%3E%0D%0A+++%3Cgroup%3E$Group%3C%2Fgroup%3E%0D%0A%3C%2Fprincipals%3E")
        $Params = @{
            Uri = $Uri
            WebSession = $Global:VIPerms.WebSession
            Method = "POST"
            Body = $Body
        }
        $Res = Invoke-WebRequest @Params
        Invoke-Logoff
        if ($SkipCertificateCheck) {
            Set-CertPolicy -ResetToDefault
        }
    } catch {
        $Err = $_
        throw $Err
    }
}