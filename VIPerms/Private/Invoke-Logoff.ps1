function Invoke-Logoff {
    <#
    .SYNOPSIS
    Logout of the authenticated vCenter MOB web session and clear up the global variable VIPerms.
    #>


    try {
        $ProPref = $ProgressPreference
        $ProgressPreference = "SilentlyContinue"
        $Uri = "https://$($Global:VIPerms.Server)/invsvc/mob3/logout"
        $Res = Invoke-WebRequest -Uri $Uri -WebSession $Global:VIPerms.WebSession -Method GET
        $Global:VIPerms.WebSession = $null
        $Global:VIPerms.SessionNonce = $null
        $ProgressPreference = $ProPref
    } catch {
        $Err = $_
        throw $Err
    }
}