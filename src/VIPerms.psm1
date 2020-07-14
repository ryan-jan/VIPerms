$Public = Get-ChildItem -Path (Join-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath "public") -ChildPath "*.ps1")
$Private = Get-ChildItem -Path (Join-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath "private") -ChildPath "*.ps1")
$Classes = Get-ChildItem -Path (Join-Path -Path (Join-Path -Path $PSScriptRoot -ChildPath "classes") -ChildPath "*.ps1")

foreach ($Module in @($Public + $Private + $Classes)) {
    try {
        . $Module.FullName
    } catch {
        Write-Error -Message "Failed to import function $($Module.FullName): $_"
    }
}

Export-ModuleMember -Function $Public.BaseName

Register-VIPermsArgCompleter

# Add HtmlAgilityPack type depending on PSVersion
try {
    if (-not ([System.Management.Automation.PSTypeName]'HtmlAgilityPack.HtmlDocument').Type) {
        $Types = Join-Path -Path $PSScriptRoot -ChildPath "Types"
        if ($PSVersionTable.PSEdition -eq "Desktop") {
            $Net45 = Join-Path -Path $Types -ChildPath "Net45"
            Add-Type -Path (Join-Path -Path $Net45 -ChildPath "HtmlAgilityPack.dll")
        } else {
            $NetStandard = Join-Path -Path $Types -ChildPath "netstandard2.0"
            Add-Type -Path (Join-Path -Path $NetStandard -ChildPath "HtmlAgilityPack.dll")
        }
    }
} catch {
    $Err = $_
    throw $Err
}