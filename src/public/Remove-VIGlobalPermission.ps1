function Remove-VIGlobalPermission {
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
        [Switch] $IsGroup
    )

    try {
        $Group = switch ($IsGroup) {
            $true {"true"}
            $false {"false"}
        }
        $Body = @{
            "principals" = @"
<principals>
  <name>$Principal</name>
  <group>$Group</group>
</principals>
"@
        }
        $Params = @{
            Uri = "AuthorizationService.RemoveGlobalAccess"
            Method = "POST"
            Body = $Body
        }
        Invoke-MobRequest @Params
    } catch {
        $Err = $_
        throw $Err
    }
}