function Get-VIMobRole {
    <#
    .SYNOPSIS
    Get roles via the Managed Object Browser (MOB)
    
    .DESCRIPTION
    Retrieve all available roles from the vCenter MOB. This is not the most effective way of retrieving this
    information. If you are using PowerCLI you should use the built in Get-VIRole CmdLet instead.
    
    .PARAMETER SkipCertificateCheck
    Skip certificate verification.
    
    .EXAMPLE
    Get-VIMobRole
    #>


    param(
        [Parameter(
            Position = 0,
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
        if ($SkipCertificateCheck) {
            Set-CertPolicy -ResetToDefault
        }
    } catch {
        $Err = $_
        throw $Err
    }
}
