function Register-VIPermsArgCompleter {
    Register-ArgumentCompleter -CommandName "Get-VIPerms" -ParameterName "Server" -ScriptBlock {
        param (
            $CommandName,
            $ParameterName,
            $WordToComplete,
            $CommandAst,
            $FakeBoundParameters
        )
        if (Test-Path "Variable:\VIPerms") {
            $global:VIPerms.Where({$_.Server -like "$WordToComplete*"}).ForEach({"'$($_.Server)'"})
        }
    }

    Register-ArgumentCompleter -CommandName "New-VIGlobalPermission" -ParameterName "Server" -ScriptBlock {
        param (
            $CommandName,
            $ParameterName,
            $WordToComplete,
            $CommandAst,
            $FakeBoundParameters
        )
        if (Test-Path "Variable:\VIPerms") {
            $global:VIPerms.Where({$_.Server -like "$WordToComplete*"}).ForEach({"'$($_.Server)'"})
        }
    }
}