Start-Sleep -Seconds 5
$CurModuleVersion = (Import-PowerShellDataFile ".\src\VIPerms.psd1").ModuleVersion
$PrevCommit = (git log --pretty=tformat:"%H")[1]
git checkout -b buildtemp $PrevCommit --quiet
$PrevModuleVersion = (Import-PowerShellDataFile ".\src\VIPerms.psd1").ModuleVersion
git checkout master --quiet
git branch -D buildtemp --quiet

if ($CurModuleVersion -gt $PrevModuleVersion) {
    Write-Output ("Module version increased from $PrevModuleVersion to $CurModuleVersion.`n" +
                  "Publishing new version to PSGallery.")
    New-Item -ItemType "Directory" -Path ".\out"
    Copy-Item -Path ".\src\" -Destination ".\out\VIPerms\" -Recurse
    New-ExternalHelp -Path ".\docs\" -OutputPath ".\out\VIPerms\en-US\"
    #Publish-Module -Path ".\out\VIPerms" -NuGetApiKey $env:PSGALLERY_KEY
}
