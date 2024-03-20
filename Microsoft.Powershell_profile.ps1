Import-Module (Resolve-Path "$PSScriptRoot\Killion-PSModules\Killion-PSModules.psm1")

$poshProfile = Join-Path $PSScriptRoot -ChildPath oh-my-posh.json

(@(& oh-my-posh init pwsh --config $poshProfile --print) -join "`n") | Invoke-Expression

$modules = @(
  [pscustomobject]@{ Name = 'Terminal-Icons'; }
  [pscustomobject]@{ Name = 'Posh-Git'; }
)

$modules | ForEach-Object {
  if (!(Get-Module -Name $_.Name)) {
    Import-Module $_.Name
  }
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
    Set-Alias -Name ($_.Name) -Value ($_.Value) -Scope Global
  }
}
