function Update-Paths {
    $paths = 'Machine', 'User', 'Process' |
    ForEach-Object {
      ([System.Environment]::GetEnvironmentVariable('Path', $_)) -split ';'
    } |
    Select-Object -Unique
    $Env:PATH = $paths -join ';'
}