function Get-VIMobRole {
    [CmdLetBinding()]
    param(
        [Parameter(
            Position = 0,
            Mandatory = $false
        )]
        [Switch] $SkipCertificateCheck
    )
    
    try {
        Write-Warning ("Get-VIMobRole is deprecated and will be removed in a later release." +
                       "Please use the VMware.PowerCLI CmdLet Get-VIRole instead.")
        $ProPref = $ProgressPreference
        $ProgressPreference = "SilentlyContinue"
        if ($SkipCertificateCheck -or $Global:VIPerms.SkipCertificateCheck) {
            Set-CertPolicy -SkipCertificateCheck
        }
        Invoke-Login
        $Uri = ("https://$($Global:VIPerms.Server)/invsvc/mob3/?moid=authorizationService&" +
                "method=AuthorizationService.GetRoles")
        $Body = "vmware-session-nonce=$($Global:VIPerms.SessionNonce)"
        $Params = @{
            Uri = $Uri
            WebSession = $Global:VIPerms.WebSession
            Method = "POST"
            Body = $Body
        }
        $Res = Invoke-WebRequest @Params
        $Table = $Res.ParsedHtml.body.getElementsByTagName("table")[3]
        $Td = $Table.getElementsByTagName("tr")[4].getElementsByTagName("td")[2]
        $Li = $Td.getElementsByTagName("ul")[0].getElementsByTagName("li")
        
        foreach ($Item in $Li) {
            if ($Item.innerHTML.StartsWith("<TABLE")) {
                $Description = $Item.getElementsByTagName("tr")[1].getElementsByTagName("td")[2].innerText
                $Id = $Item.getElementsByTagName("tr")[4].getElementsByTagName("td")[2].innerText
                $Name = $Item.getElementsByTagName("tr")[5].getElementsByTagName("td")[2].innerText

                [PSCustomObject] @{
                    Name = $Name
                    Description = $Description
                    Id = $Id
                }
            }
        }
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
