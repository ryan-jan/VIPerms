function Invoke-Login {
    <#
    .SYNOPSIS
    Authenticate against vCenter MOB

    .DESCRIPTION
    Authenticate against vCenter MOB and grab the vmware-session-nonce. This is then stored in the global 
    VIPerms hashtable along with the session variable from the web request.   
    #>

    try {
        if (!($Global:VIPerms.Server) -or ([String]::IsNullOrEmpty($Global:VIPerms.Server)) -or
            !($Global:VIPerms.Credential) -or ([String]::IsNullOrEmpty($Global:VIPerms.Credential))) {
            throw "Please authenticate using Connect-VIMobServer first!"
        }
        $Uri = ("https://$($Global:VIPerms.Server)/invsvc/mob3/?moid=authorizationService&" +
                "method=AuthorizationService.GetRoles")
        
        # Initial login to vSphere MOB to store session variable
        $Params = @{
            Uri = $Uri
            SessionVariable = "MobSession"
            Credential = $Global:VIPerms.Credential
            Method = "GET"
        }
        $Res = Invoke-WebRequest @Params
        
        # Extract hidden vmware-session-nonce which must be included in future requests to prevent CSRF error
        # Credit to https://blog.netnerds.net/2013/07/use-powershell-to-keep-a-cookiejar-and-post-to-a-web-form/ for
        # parsing vmware-session-nonce via Powershell
        if ($Res.StatusCode -eq 200) {
            $null = $Res -match 'name="vmware-session-nonce" type="hidden" value="?([^\s^"]+)"'
            $Global:VIPerms.SessionNonce = $Matches[1]
            $Global:VIPerms.WebSession = $MobSession
        } else {
            throw "Failed to login to vSphere MOB"
        }
    } catch {
        $Err = $_
        throw $Err
    }
}