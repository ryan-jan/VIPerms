function Get-VIGlobalPermission {
    <#
    .SYNOPSIS
    Get one or more global permissions.
    
    .DESCRIPTION
    Return information relating to one or more global permissions. This is not very performant as it literally
    parses the html from the response of the vSphere MOB to get the information. This appears to be the
    only way to achieve this currently as there is no public API available for vSphere global permissions. 
    
    .PARAMETER SkipCertificateCheck
    Skip certificate verification.
    
    .EXAMPLE
    Get-VIGlobalPermission

    Principal                                                            PrincipalType Role            Propagate
    ---------                                                            ------------- ----            ---------
    VSPHERE.LOCAL\vpxd-extension-b2df90b0-1e03-11e6-b844-005056bf2aaa    User          Admin           true
    VSPHERE.LOCAL\vpxd-b2df90b0-1e03-11e6-b844-005056bf2aaa              User          Admin           true
    VSPHERE.LOCAL\vsphere-webclient-b2df90b0-1e03-11e6-b844-005056bf2aaa User          Admin           true
    VSPHERE.LOCAL\Administrators                                         Group         Admin           true
    VSPHERE.LOCAL\Administrator                                          User          Admin           true
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
        $VIRoles = Get-VIMobRole
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
                $PrincipalType = switch ($IsGroup) {
                    $true {"Group"}
                    $false {"User"}
                }
                $Role = $Item.getElementsByTagName("tr")[10].getElementsByTagName("li")[0].innerText
                $Propagate = $Item.getElementsByTagName("tr")[9].getElementsByTagName("td")[2].innerText

                [PSCustomObject] @{
                    Principal = $Principal
                    PrincipalType = $PrincipalType
                    Role = $RoleLookup.$($Role)
                    Propagate = $Propagate
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
