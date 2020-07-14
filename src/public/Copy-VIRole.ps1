function Copy-VIRole {
    [CmdletBinding()]
    param (
        [string] $SourceServer,
        [string[]] $DestinationServer,
        [string] $Name
    )

    try {
        $SourceRole = Get-VIRole -Server $SourceServer -Name $Name -ErrorAction "Stop"
    } catch {
        throw $_
    }
    foreach ($DestServer in $DestinationServer) {
        $DestPrivs = foreach ($Priv in $SourceRole.PrivilegeList) {
            try {
                Get-VIPrivilege -Server $DestServer -Id $Priv -ErrorAction "Stop"
            } catch {
                $Err = $_
                if ($Err.Exception.Message -like "*VIPrivilege with id * was not found*") {
                    Write-Warning ("VIPrivilege with id $Priv was not found on the destination server " +
                                   "($DestServer) and will not be added to the new role.")
                } else {
                    throw $Err
                }
            }
        }
        New-VIRole -Server $DestServer -Name $SourceRole.Name -Privilege $DestPrivs
    }
}