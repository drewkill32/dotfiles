(@(& 'C:/Users/adk/AppData/Local/Programs/oh-my-posh/bin/oh-my-posh.exe' init pwsh --config='D:\Code\dotfiles\oh-my-posh.json' --print) -join "`n") | Invoke-Expression

if ($host.Name -eq 'ConsoleHost') {
  Import-Module PSReadLine
}

Import-Module -Name Terminal-Icons

Set-PSReadLineOption -PredictionSource History -WarningAction Ignore
Set-PSReadLineOption -PredictionViewStyle ListView -WarningAction Ignore
Set-PSReadLineOption -EditMode Windows -WarningAction Ignore


# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

Set-Alias -Name touch -Value New-Item


