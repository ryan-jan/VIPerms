function Export-VIRolePrivs {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $Server = $global:DefaultVIServer.Name,

        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $true)]
        [string[]] $Name,

        [Parameter(Mandatory = $true)]
        [ValidateScript({$_ -like "*.json"})]
        [System.IO.FileInfo] $Path 
    )

    try {
        $Export = @{
            "_VIPermsSchemaVersion_" = 1
            "Roles" = @()
        }
        foreach ($Role in $Name) {
            $VIRole = (Get-VIRole -Server $Server -Name $Role)[0]
            $Export.Roles += @{
                "Name" = $VIRole.Name
                "PrivilegeList" = $VIRole.PrivilegeList
            }
        }
        $Export | ConvertTo-Json -Depth 4 | Set-Content -Path $Path
    } catch {
        $Err = $_
        throw $Err
    }
}