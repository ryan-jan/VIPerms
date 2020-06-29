function Get-VIGlobalPermission {
    [CmdLetBinding()]
    param()
    
    try {
        $VIRoles = Get-VIRole
        $Params = @{
            Uri = "AuthorizationService.GetGlobalAccessControlList"
            Method = "POST"
        }
        $Res = Invoke-MobRequest @Params
        $RoleLookup = @{}
        foreach ($VIRole in $VIRoles) {
            $RoleLookup.$($VIRole.Id) = $VIRole.Name
        }
        $HtmlDoc = [HtmlAgilityPack.HtmlDocument]::new()
        $HtmlDoc.LoadHtml($Res.RawContent.ToString())
        $List = $HtmlDoc.DocumentNode.SelectNodes("//table[3]/tr[5]/td[3]/ul[1]/li")
        foreach ($Item in $List) {
            $Principal = $Item.SelectNodes("table[1]/tr[4]/td[3]/table[1]/tr[5]/td[3]").InnerText
            $IsGroup = $Item.SelectNodes("table[1]/tr[4]/td[3]/table[1]/tr[4]/td[3]").InnerText
            $Role = [int] $Item.SelectNodes("table[1]/tr[6]/td[3]/ul[1]/li[1]").InnerText
            $Propagate = $Item.SelectNodes("table[1]/tr[5]/td[3]").InnerText
            [PSCustomObject] @{
                Role = $RoleLookup.$($Role)
                Principal = $Principal
                Propagate = [boolean] $Propagate
                IsGroup = [boolean] $IsGroup
            }
        }
    } catch {
        $Err = $_
        throw $Err
    }
}
