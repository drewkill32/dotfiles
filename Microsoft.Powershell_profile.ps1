$poshProfile = Join-Path $PSScriptRoot -ChildPath oh-my-posh.json
(@(& oh-my-posh init pwsh --config $poshProfile --print) -join "`n") | Invoke-Expression

if ($host.Name -eq 'ConsoleHost') {
  Import-Module PSReadLine
}

if (!(Get-Module -ListAvailable -Name Terminal-Icons)) {
  Import-Module Terminal-Icons
}

if (!(Get-Module -ListAvailable -Name Posh-Git)) {
  Import-Module Posh-Git
} 

Set-PSReadLineOption -PredictionSource History -WarningAction Ignore
Set-PSReadLineOption -PredictionViewStyle ListView -WarningAction Ignore
Set-PSReadLineOption -EditMode Windows -WarningAction Ignore


# Alaises
$alaises = @(
  [pscustomobject]@{ Name = 'touch'; Value = 'New-Item' }
  [pscustomobject]@{ Name = 'grep'; Value = 'Select-String' }
  [pscustomobject]@{ Name = 'man'; Value = 'Get-Help' }
  [pscustomobject]@{ Name = 'sql'; Value = 'Invoke-Sqlcmd' }
)
$alaises | ForEach-Object {
  if (!(Get-Alias -Name $_.Name)) {
    Set-Alias -Name $_.Name -Value $_.Value
  }
}


# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}



function Update-Paths {
  $paths = 'Machine', 'User' |
  ForEach-Object {
    ([System.Environment]::GetEnvironmentVariable('Path', $_)) -split ';'
  } |
  Select-Object -Unique
  $Env:PATH = $paths -join ';'
}


