param (
    [switch] $Test,
    [switch] $CodeCov,
    [switch] $ExtDocs,
    [switch] $Deploy
)

Write-Host "Running on PowerShell $($PSVersionTable.PSEdition) $($PSVersionTable.PSVersion.ToString())"
$SrcPath = Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath "src"
$OutPath = Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath "out"
$ModulePath = Join-Path -Path $OutPath -ChildPath "VIPerms"
$TestScript = Join-Path -Path $PSScriptRoot -ChildPath "Invoke-Tests.ps1"

if (-not (Test-Path -Path $OutPath)) {
    New-Item -Path $OutPath -ItemType "Directory" -Confirm:$false
}
Copy-Item -Path $SrcPath -Destination $ModulePath -Recurse

if ($ExtDocs) {
    $DocsPath = Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath "docs"
    New-ExternalHelp -Path $DocsPath -OutputPath (Join-Path -Path $ModulePath -ChildPath "en-US")
}

Import-Module $ModulePath

if ($Test) {
    if ($CodeCov) {
        & $TestScript -CodeCov
    } else {
        & $TestScript
    }
}

if ($Deploy) {
    if ($env:APPVEYOR_REPO_TAG -eq "true") {
        $ManifestPath = Join-Path -Path $ModulePath -ChildPath "VIPerms.psd1"
        $CurModuleVersion = (Import-PowerShellDataFile -Path $ManifestPath).ModuleVersion
    
        if ($env:APPVEYOR_REPO_TAG_NAME -like "v$($CurModuleVersion.ToString())") {
            Write-Host "Current commit has been tagged with a new version. Pushing to PowerShell Gallery."
            Publish-Module -Path $ModulePath -NuGetApiKey $env:PSGALLERY_KEY
        } else {
            throw ("Current commit has been tagged with a new version, " +
                   "but the version differs from that specified in the module manifest.")
        }
    }
}
