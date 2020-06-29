function New-VIGlobalPermission {
    [CmdLetBinding()]
    param (
        [Parameter(
            Position = 0,
            Mandatory = $true
        )]
        [String] $Principal,

        [Parameter(
            Position = 1,
            Mandatory = $false
        )]
        [Switch] $IsGroup,

        [Parameter(
            Position = 2,
            Mandatory = $true
        )]
        [String] $Role,

        [Parameter(
            Position = 3,
            Mandatory = $false
        )]
        [Switch] $Propagate
    )
    
    try {
        $Group = switch ($IsGroup) {
            $true {"true"}
            $false {"false"}
        }
        $Prop = switch ($Propagate) {
            $true {"true"}
            $false {"false"}
        }

        $Body = @{
            "permissions" = @"
<permissions>
  <principal>
    <name>$Principal</name>
    <group>$Group</group>
  </principal>
  <roles>$Role</roles>
  <propagate>$Prop</propagate>
  <version>42</version>
</permissions>
"@
        }
        
        $Params = @{
            Uri = "AuthorizationService.AddGlobalAccessControlList"
            Method = "POST"
            Body = $Body
        }
        Invoke-MobRequest @Params
    } catch {
        $Err = $_
        throw $Err
    }
}