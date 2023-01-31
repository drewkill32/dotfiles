$ScriptPath = Join-Path $PSScriptRoot -ChildPath Microsoft.Powershell_profile.ps1
$AddProfileStatement = @("& $($ScriptPath)")



$content = Get-Content $PROFILE
if ($content -notcontains $AddProfileStatement) {
    $content = $AddProfileStatement + "`n" + (Get-Content $PROFILE)
    Set-Content -Path $PROFILE -Value $content
    $content | Select-Object -First 10
}


