function Get-VIPerms {
    [CmdLetBinding()]
    param(
        [string[]] $Server,
        [switch] $ExcludeGlobal
    )
    
    try {
        if (-not $Server) {
            $Server = Get-DefaultVIPermsServer
        }

        foreach ($Srv in $Server) {
            if (-not $ExcludeGlobal) {
                $VIRoles = Get-VIRole
                $Params = @{
                    Server = $Srv
                    Uri = "AuthorizationService.GetGlobalAccessControlList"
                    Method = "POST"
                }
                $Res = Invoke-MobRequest @Params
                $RoleLookup = @{}
                foreach ($VIRole in $VIRoles) {
                    $RoleLookup.$($VIRole.Id) = $VIRole.Name
                }
                $HtmlDoc = [HtmlAgilityPack.HtmlDocument]::new()
                $HtmlDoc.LoadHtml($Res)
                $List = $HtmlDoc.DocumentNode.SelectNodes("//table[3]/tr[5]/td[3]/ul[1]/li")
                foreach ($Item in $List) {
                    [VIPermsPermission]::new($Item, $RoleLookup)
                }
            }
            $VIPermissions = Get-VIPermission
            foreach ($Perm in $VIPermissions) {
                [VIPermsPermission]::new($Perm)
            }
        }
    } catch {
        $Err = $_
        throw $Err
    }
}
