# SPDX-FileCopyrightText: 2026 24by
# SPDX-License-Identifier: CC0-1.0

param([string]$PrismDir)

$ErrorActionPreference = 'Stop'

if (-not $PrismDir) {
    if (-not $env:APPDATA) {
        throw 'Pass your Prism data folder with -PrismDir.'
    }
    $PrismDir = Join-Path $env:APPDATA 'PrismLauncher'
}

$theme = Join-Path $PSScriptRoot 'themes/Chapter-One-Lobby'
$icons = Join-Path $PSScriptRoot 'icons/Chapter-One-Lobby'
$controls = @(Get-ChildItem -LiteralPath (Join-Path $theme 'resources') -Filter '*.svg' -File)
$glyphs = @(Get-ChildItem -LiteralPath (Join-Path $icons 'scalable') -Filter '*.svg' -File)
$themeFiles = @(
    Get-Item -LiteralPath (Join-Path $theme 'theme.json')
    Get-Item -LiteralPath (Join-Path $theme 'themeStyle.css')
)
$index = Get-Item -LiteralPath (Join-Path $icons 'index.theme')
if ($controls.Count -eq 0 -or $glyphs.Count -eq 0) {
    throw 'Extract the entire ZIP before running install.ps1.'
}

$themeTarget = Join-Path $PrismDir 'themes/Chapter-One-Lobby'
$iconTarget = Join-Path $PrismDir 'iconthemes/Chapter-One-Lobby'
$glyphTarget = Join-Path $iconTarget 'scalable'
$controlTarget = Join-Path $themeTarget 'resources'
$null = [IO.Directory]::CreateDirectory($controlTarget)
$null = [IO.Directory]::CreateDirectory($glyphTarget)

foreach ($file in $themeFiles) {
    [IO.File]::Copy($file.FullName, (Join-Path $themeTarget $file.Name), $true)
}
foreach ($file in $controls) {
    [IO.File]::Copy($file.FullName, (Join-Path $controlTarget $file.Name), $true)
}
[IO.File]::Copy($index.FullName, (Join-Path $iconTarget $index.Name), $true)
foreach ($file in $glyphs) {
    [IO.File]::Copy($file.FullName, (Join-Path $glyphTarget $file.Name), $true)
}

Write-Host "Installed in $PrismDir"
Write-Host 'Restart Prism and select Chapter One Lobby for Widgets and Icons.'
