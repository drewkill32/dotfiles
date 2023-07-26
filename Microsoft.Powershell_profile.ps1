function Update-Paths {
  $paths = 'Machine', 'User' |
  ForEach-Object {
    ([System.Environment]::GetEnvironmentVariable('Path', $_)) -split ';'
  } |
  Select-Object -Unique
  $Env:PATH = $paths -join ';'
}

if ((Get-PSRepository PSGallery).InstallationPolicy -ne "Trusted") {
  Set-PSRepository PSGallery -InstallationPolicy Trusted
}

if (!(Get-Command oh-my-posh -ErrorAction Ignore)) {
  winget install JanDeDobbeleer.OhMyPosh -s winget
  Update-Paths
}

$poshProfile = Join-Path $PSScriptRoot -ChildPath oh-my-posh.json


(@(& oh-my-posh init pwsh --config $poshProfile --print) -join "`n") | Invoke-Expression

if ($host.Name -eq 'ConsoleHost') {
  Import-Module PSReadLine
}

if (!(Get-Module -ListAvailable -Name Terminal-Icons)) {
  Install-Module Terminal-Icons -Scope CurrentUser
  Import-Module Terminal-Icons
}

if (!(Get-Module -ListAvailable -Name Posh-Git)) {
  Install-Module Posh-Git -Scope CurrentUser
  Import-Module Posh-Git
} 

if (!(Get-Module -Name PSReadLine -ListAvailable | Where-Object Version -ge 2.2.6)) {
  Install-Module PSReadLine -Scope CurrentUser -MinimumVersion 2.2.6 -Force
  Import-Module PSReadLine
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
  if (!(Get-Alias -Name $_.Name -ErrorAction Ignore)) {
    Set-Alias -Name $_.Name -Value $_.Value
  }
}





