$ScriptPath = Join-Path $PSScriptRoot -ChildPath Microsoft.Powershell_profile.ps1
$AddProfileStatement = @("& $($ScriptPath)")


Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

function Update-Paths {
    $paths = 'Machine', 'User', 'Process' |
    ForEach-Object {
      ([System.Environment]::GetEnvironmentVariable('Path', $_)) -split ';'
    } |
    Select-Object -Unique
    $Env:PATH = $paths -join ';'
}
  

if (!(Get-Command oh-my-posh -ErrorAction Ignore)) {
    winget install JanDeDobbeleer.OhMyPosh -s winget
    Update-Paths
}


if (!(Get-Module -ListAvailable -Name Terminal-Icons)) {
    Install-Module Terminal-Icons -Scope CurrentUser
}
  
  
if (!(Get-Module -ListAvailable -Name Posh-Git)) {
    Install-Module Posh-Git -Scope CurrentUser
} 

if (!(Get-Module -Name PSReadLine -ListAvailable | Where-Object Version -GE 2.2.6)) {
    Install-Module PSReadLine -Scope CurrentUser -MinimumVersion 2.2.6 -Force
} 
  
if (Get-Module -Name PSReadLine | Where-Object Version -GE 2.2.6) {
    Import-Module PSReadLine -MinimumVersion 2.2.6 -Force -NoClobber
}


if (!(Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE
}

$content = Get-Content $PROFILE
if ($content -notcontains $AddProfileStatement) {
    $content = $AddProfileStatement + "`n" + (Get-Content $PROFILE)
    Set-Content -Path $PROFILE -Value $content
    $content | Select-Object -First 10
}


