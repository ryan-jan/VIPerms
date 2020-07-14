class VIPermsPermission {
    [string] $Entity
    [string] $EntityId
    [bool] $IsGroup
    [string] $Principal
    [bool] $Propagate
    [string] $Role
    [int] $RoleId

    VIPermsPermission () {}

    VIPermsPermission ($Perm) {
        # Construct class using PowerCLI data
        $this.Entity = $Perm.Entity
        $this.EntityId = $Perm.EntityId.ToString()
        $this.IsGroup = $Perm.IsGroup
        $this.Principal = $Perm.Principal
        $this.Propagate = $Perm.Propagate
        $this.Role = $Perm.Role
        $this.RoleId = $Perm.ExtensionData.RoleId
    }

    VIPermsPermission ($Item, $RoleLookup) {
        # Construct class using HTML raw data from vCenter MOB
        $RoleIdInt = [int] $Item.SelectNodes("table[1]/tr[6]/td[3]/ul[1]/li[1]").InnerText
        $this.Entity = "Global"
        $this.EntityId = "Global"
        $this.IsGroup = [System.Convert]::ToBoolean($Item.SelectNodes("table[1]/tr[4]/td[3]/table[1]/tr[4]/td[3]").InnerText)
        $this.Principal = $Item.SelectNodes("table[1]/tr[4]/td[3]/table[1]/tr[5]/td[3]").InnerText
        $this.Propagate = [System.Convert]::ToBoolean($Item.SelectNodes("table[1]/tr[5]/td[3]").InnerText)
        $this.Role = $RoleLookup.$($RoleIdInt)
        $this.RoleId = $RoleIdInt
    }
}