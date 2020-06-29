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

# Add HtmlAgilityPack type depending on PSVersion
try {
    if (-not ([System.Management.Automation.PSTypeName]'HtmlAgilityPack.HtmlDocument').Type) {
        if ($PSVersionTable.PSEdition -eq "Desktop") {
            Add-Type -Path "$PSScriptRoot\Types\Net45\HtmlAgilityPack.dll"
        } else {
            Add-Type -Path "$PSScriptRoot\Types\netstandard2.0\HtmlAgilityPack.dll"
        }
    }
} catch {
    $Err = $_
    throw $Err
}