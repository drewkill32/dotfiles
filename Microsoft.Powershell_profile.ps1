function Update-Paths {
  $paths = 'Machine', 'User', 'Process' |
  ForEach-Object {
    ([System.Environment]::GetEnvironmentVariable('Path', $_)) -split ';'
  } |
  Select-Object -Unique
  $Env:PATH = $paths -join ';'
}




$poshProfile = Join-Path $PSScriptRoot -ChildPath oh-my-posh.json


(@(& oh-my-posh init pwsh --config $poshProfile --print) -join "`n") | Invoke-Expression


if ($host.Name -eq 'ConsoleHost') {

}


if (!(Get-Module -ListAvailable -Name Terminal-Icons)) {
  Install-Module Terminal-Icons -Scope CurrentUser
  Import-Module Terminal-Icons
}


if (!(Get-Module -ListAvailable -Name Posh-Git)) {
  Install-Module Posh-Git -Scope CurrentUser
  Import-Module Posh-Git
} 
$env:POSH_GIT_ENABLED = $true



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






