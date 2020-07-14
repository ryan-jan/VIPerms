function Remove-VIGlobalPermission {
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
        [Switch] $IsGroup
    )

    try {
        if (-not $Server) {
            $Server = Get-DefaultVIPermsServer
        }
        $Group = switch ($IsGroup) {
            $true {"true"}
            $false {"false"}
        }
        foreach ($Srv in $Server) {
            $Body = @{
                "principals" = @"
<principals>
  <name>$Principal</name>
  <group>$Group</group>
</principals>
"@
            }
            $Params = @{
                Server = $Srv
                Uri = "AuthorizationService.RemoveGlobalAccess"
                Method = "POST"
                Body = $Body
            }
            Invoke-MobRequest @Params
        }
    } catch {
        $Err = $_
        throw $Err
    }
}