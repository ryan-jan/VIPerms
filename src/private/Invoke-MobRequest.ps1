function Invoke-MobRequest {
    [CmdletBinding()]
    param (
        [string] $Uri,
        [string] $Method,
        [hashtable] $Body,
        [switch] $TestConnection
    )

    try {
        $ProPref = $ProgressPreference
        $ProgressPreference = "SilentlyContinue"

        if ([string]::IsNullOrEmpty($global:VIPerms.Server)) {
            throw "Please authenticate using Connect-VIMobServer first!"
        }
        $BaseUri = "https://$($global:VIPerms.Server)/invsvc/mob3/?moid=authorizationService&method="

        if (($global:VIPerms.SkipCertificateCheck) -and ($PSVersionTable.PSEdition -eq "Desktop")) {
            Set-CertPolicy -SkipCertificateCheck
        }

        # Initial GET request is just to grab the vmware-session-nonce variable in order to make other requests.
        $LogonParams = @{
            Uri = "$($BaseUri)AuthorizationService.GetRoles"
            SessionVariable = "MobSession"
            Credential = $Global:VIPerms.Credential
            Method = "GET"
            ContentType = "application/x-www-form-urlencoded"
            UseBasicParsing = $true
        }
        if ($PSVersionTable.PSEdition -eq "Core") {
            $LogonParams.SkipCertificateCheck = $global:VIPerms.SkipCertificateCheck
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
                $ReqParams.SkipCertificateCheck = $global:VIPerms.SkipCertificateCheck
            }
            Invoke-RestMethod @ReqParams
        }

        $LogoffParams = @{
            Uri = "https://$($global:VIPerms.Server)/invsvc/mob3/logout"
            WebSession = $MobSession
            Method = "GET"
            ContentType = "application/x-www-form-urlencoded"
            UseBasicParsing = $true
        }
        if ($PSVersionTable.PSEdition -eq "Core") {
            $LogoffParams.SkipCertificateCheck = $global:VIPerms.SkipCertificateCheck
        }
        Invoke-RestMethod @LogoffParams | Out-Null
        $ProgressPreference = $ProPref
    } catch {
        $Err = $_
        throw $Err
    }
}