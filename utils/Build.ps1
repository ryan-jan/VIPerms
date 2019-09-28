Write-Host "TODO:- Write some freaking tests mate so that this sh*t don't break yeah!"
Start-Sleep -Seconds 5
$CurModuleVersion = (Import-PowerShellDataFile ".\VIPerms\VIPerms.psd1").ModuleVersion
$PrevCommit = (cmd /c git log --pretty=tformat:"%H")[1]
cmd /c git checkout -b buildtemp $PrevCommit --quiet
$PrevModuleVersion = (Import-PowerShellDataFile ".\VIPerms\VIPerms.psd1").ModuleVersion
cmd /c git checkout master --quiet
cmd /c git branch -D buildtemp --quiet

if ($CurModuleVersion -gt $PrevModuleVersion) {
    Write-Output ("Module version increased from $PrevModuleVersion to $CurModuleVersion.`n" +
                  "Publishing new version on PSGallery.")
    Publish-Module -Path "$PSScriptRoot\..\VIPerms" -NuGetApiKey $env:PSGALLERY_KEY
}
