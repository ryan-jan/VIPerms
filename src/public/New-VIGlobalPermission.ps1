function New-VIGlobalPermission {
    [CmdLetBinding()]
    param (
        [Parameter(
            Mandatory = $false
        )]
        [string[]] $Server,

        [Parameter(
            Mandatory = $true
        )]
        [String] $Principal,

        [Parameter(
            Mandatory = $false
        )]
        [Switch] $IsGroup,

        [Parameter(
            Mandatory = $true
        )]
        [String] $Role,

        [Parameter(
            Mandatory = $false
        )]
        [Switch] $Propagate
    )
    
    try {
        if (-not $Server) {
            $Server = Get-DefaultVIPermsServer
        }
        $Group = switch ($IsGroup) {
            $true {"true"}
            $false {"false"}
        }
        $Prop = switch ($Propagate) {
            $true {"true"}
            $false {"false"}
        }

        foreach ($Srv in $Server) {
            $VIRole = Get-VIRole -Server $Srv -Name $Role -ErrorAction "Stop"

            $Body = @{
                "permissions" = @"
<permissions>
  <principal>
    <name>$Principal</name>
    <group>$Group</group>
  </principal>
  <roles>$($VIRole.Id)</roles>
  <propagate>$Prop</propagate>
  <version>42</version>
</permissions>
"@
            }
        
            $Params = @{
                Server = $Srv
                Uri = "AuthorizationService.AddGlobalAccessControlList"
                Method = "POST"
                Body = $Body
            }
            $Res = Invoke-MobRequest @Params
            $HtmlDoc = [HtmlAgilityPack.HtmlDocument]::new()
            $HtmlDoc.LoadHtml($Res)
            if ($HtmlDoc.DocumentNode.SelectNodes("//body/p[last()]").InnerText -like "*void*") {
                Write-Verbose "Global permission created successfully."
                $Perm = [VIPermsPermission]::new()
                $Perm.Entity = "Global"
                $Perm.EntityId = "Global"
                $Perm.IsGroup = $IsGroup
                $Perm.Principal = $Principal
                $Perm.Propagate = $Propagate
                $Perm.Role = $VIRole.Name
                $Perm.RoleId = $VIRole.Id
                $Perm
            } else {
                throw $HtmlDoc.DocumentNode.SelectNodes("//body/p[last()]").InnerText
            }
        }
    } catch {
        $Err = $_
        throw $Err
    }
}