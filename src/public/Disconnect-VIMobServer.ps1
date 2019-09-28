function Disconnect-VIMobServer {
    [CmdLetBinding()]
    param ()
    try {
        Remove-Variable -Name "VIPerms" -Scope "Global"
    } catch {
        $Err = $_
        throw $Err
    }
}