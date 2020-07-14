function Invoke-MobRequest {
    [CmdletBinding()]
    param (
        [string] $Server,
        [string] $Uri,
        [string] $Method,
        [hashtable] $Body,
        [switch] $TestConnection
    )

    try {
        $ProPref = $ProgressPreference
        $ProgressPreference = "SilentlyContinue"

        $Conn = $global:VIPerms.Where({$_.Server -eq $Server})[0]

        if ($null -eq $Conn) {
            throw "Please authenticate using Connect-VIMobServer first!"
        }
        $BaseUri = "https://$($Conn.Server):$($Conn.Port)/invsvc/mob3/?moid=authorizationService&method="

        if (($Conn.SkipCertificateCheck) -and ($PSVersionTable.PSEdition -eq "Desktop")) {
            Set-CertPolicy -SkipCertificateCheck
        }

        # Initial GET request is just to grab the vmware-session-nonce variable in order to make other requests.
        $LogonParams = @{
            Uri = "$($BaseUri)AuthorizationService.GetRoles"
            SessionVariable = "MobSession"
            Credential = $Conn.Credential
            Method = "GET"
            ContentType = "application/x-www-form-urlencoded"
            UseBasicParsing = $true
        }
        if ($PSVersionTable.PSEdition -eq "Core") {
            $LogonParams.SkipCertificateCheck = $Conn.SkipCertificateCheck
        }
        $Res = Invoke-RestMethod @LogonParams
        
        # Extract hidden vmware-session-nonce which must be included in future requests to prevent CSRF error
        # Credit to https://blog.netnerds.net/2013/07/use-powershell-to-keep-a-cookiejar-and-post-to-a-web-form/ for
        # parsing vmware-session-nonce via Powershell
        $RegexMatch = $Res -match 'name="vmware-session-nonce" type="hidden" value="?([^\s^"]+)"'
        $SessionNonce = $Matches[1]

        if ($TestConnection) {
            $true
        } else {
            if ($Body) {
                $ReqBody = @{"vmware-session-nonce" = $SessionNonce} + $Body
            } else {
                $ReqBody = @{"vmware-session-nonce" = $SessionNonce}
            }
            $ReqParams = @{
                Uri = "$($BaseUri)$($Uri)"
                WebSession = $MobSession
                Method = $Method
                Body = $ReqBody
                ContentType = "application/x-www-form-urlencoded"
                UseBasicParsing = $true
            }
            if ($PSVersionTable.PSEdition -eq "Core") {
                $ReqParams.SkipCertificateCheck = $Conn.SkipCertificateCheck
            }
            Invoke-RestMethod @ReqParams
        }

        $LogoffParams = @{
            Uri = "https://$($Conn.Server):$($Conn.Port)/invsvc/mob3/logout"
            WebSession = $MobSession
            Method = "GET"
            ContentType = "application/x-www-form-urlencoded"
            UseBasicParsing = $true
        }
        if ($PSVersionTable.PSEdition -eq "Core") {
            $LogoffParams.SkipCertificateCheck = $Conn.SkipCertificateCheck
        }
        Invoke-RestMethod @LogoffParams | Out-Null
        $ProgressPreference = $ProPref
    } catch {
        $Err = $_
        throw $Err
    }
}