# Telewhite: установка и обновление до последней сборки.
# Запуск в PowerShell:
#   irm https://raw.githubusercontent.com/lucudar/telewhite-build/main/install.ps1 | iex
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$dir = Join-Path $env:LOCALAPPDATA 'Programs\Telewhite'
$exe = Join-Path $dir 'Telegram.exe'
$headers = @{ 'User-Agent' = 'Telewhite-Installer' }

Write-Host 'Telewhite: ищу последнюю сборку...'
$release = Invoke-RestMethod -Uri 'https://api.github.com/repos/lucudar/telewhite-build/releases/latest' -Headers $headers
$asset = $release.assets | Where-Object { $_.name -like '*.zip' } | Select-Object -First 1
if (-not $asset) { throw 'В последнем релизе нет zip-файла.' }

$running = Get-Process -Name 'Telegram' -ErrorAction SilentlyContinue | Where-Object { $_.Path -eq $exe }
foreach ($process in $running) {
    Write-Host 'Закрываю запущенный Telewhite...'
    $process.CloseMainWindow() | Out-Null
    if (-not $process.WaitForExit(10000)) { $process | Stop-Process -Force }
}

New-Item -ItemType Directory -Force -Path $dir | Out-Null
$zip = Join-Path $env:TEMP 'Telewhite-x64.zip'
Write-Host "Скачиваю $($release.name)..."
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zip -Headers $headers
Expand-Archive -Path $zip -DestinationPath $dir -Force
Remove-Item $zip -Force
Get-ChildItem -Path $dir -Recurse -File | Unblock-File

$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut((Join-Path ([Environment]::GetFolderPath('Desktop')) 'Telewhite.lnk'))
$shortcut.TargetPath = $exe
$shortcut.WorkingDirectory = $dir
$shortcut.Save()

Write-Host "Готово: $($release.name)"
Write-Host "Папка: $dir"
Start-Process -FilePath $exe -WorkingDirectory $dir
