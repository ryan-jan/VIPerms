$Private = @(Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1")
$Public = @(Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1")

foreach ($Module in @($Private + $Public)) {
    try {
        . $Module.FullName
    } catch {
        Write-Error -Message "Failed to import function $($Module.FullName): $_"
    }
}

Export-ModuleMember -Function $Public.BaseName