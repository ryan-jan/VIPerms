function Get-DefaultVIPermsServer {
    if ((Get-PowerCLIConfiguration -Scope Session).DefaultVIServerMode -eq "Multiple") {
        $global:VIPerms.Server
    } else {
        $global:VIPerms.Server[0]
    }
}