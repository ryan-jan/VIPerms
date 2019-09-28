function Get-VIGlobalPermission {
    [CmdLetBinding()]
    param(
        [Parameter(
            Position = 0,
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
        $VIRoles = Get-VIRole
        Invoke-Login
        $Uri = ("https://$($Global:VIPerms.Server)/invsvc/mob3/?moid=authorizationService&" +
                "method=AuthorizationService.GetGlobalAccessControlList")
        $Body = "vmware-session-nonce=$($Global:VIPerms.SessionNonce)"
        $Params = @{
            Uri = $Uri
            WebSession = $Global:VIPerms.WebSession
            Method = "POST"
            Body = $Body
        }
        $Res = Invoke-WebRequest @Params
        $RoleLookup = @{}
        foreach ($VIRole in $VIRoles) {
            $RoleLookup."$($VIRole.Id)" = $VIRole.Name
        }
        $Table = $Res.ParsedHtml.body.getElementsByTagName("table")[3]
        $Td = $Table.getElementsByTagName("tr")[4].getElementsByTagName("td")[2]
        $Li = $Td.getElementsByTagName("ul")[0].getElementsByTagName("li")
        
        foreach ($Item in $Li) {
            if ($Item.innerHTML.StartsWith("<TABLE")) {
                $PrinTable = $Item.getElementsByTagName(
                    "tr")[3].getElementsByTagName("td")[2].getElementsByTagName("table")[0]
                $Principal = $PrinTable.getElementsByTagName("tr")[4].getElementsByTagName("td")[2].innerText
                $IsGroup = $PrinTable.getElementsByTagName("tr")[3].getElementsByTagName("td")[2].innerText
                $Role = $Item.getElementsByTagName("tr")[10].getElementsByTagName("li")[0].innerText
                $Propagate = $Item.getElementsByTagName("tr")[9].getElementsByTagName("td")[2].innerText

                [PSCustomObject] @{
                    Role = $RoleLookup.$($Role)
                    Principal = $Principal
                    Propagate = [Boolean] $Propagate
                    IsGroup = [Boolean] $IsGroup
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
