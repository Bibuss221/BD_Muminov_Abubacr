# Создание переносимого Windows-комплекта RentalCarSystem.
#
# После сборки windeployqt раскладывает библиотеки Qt рядом с приложением.
# Дополнительно копируется клиент PostgreSQL, необходимый QPSQL.

param(
    [string]$QtDir,
    [string]$BuildDir = "build",
    [string]$OutputDir = "dist",
    [switch]$SkipBuild,
    [switch]$NoArchive
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

function Find-Newest([string]$pattern)
{
    $found = Get-ChildItem $pattern -Directory -ErrorAction SilentlyContinue |
        Sort-Object Name -Descending

    if ($found) {
        return $found[0].FullName
    }

    return $null
}

if (-not $QtDir) {
    $QtDir = Find-Newest "C:\Qt\6.*\mingw_64"
}

if (-not $QtDir) {
    throw "Qt не найден. Укажите путь параметром -QtDir."
}

$qtBin = Join-Path $QtDir "bin"
$windeployqt = Join-Path $qtBin "windeployqt.exe"

if (-not (Test-Path $windeployqt)) {
    throw "windeployqt.exe не найден: $windeployqt"
}

$pgBin = Find-Newest "C:\Program Files\PostgreSQL\*\bin"

$env:PATH = "$qtBin;$($env:PATH)"

if (-not $SkipBuild) {
    powershell -ExecutionPolicy Bypass -File "$root\scripts\build_and_run.ps1" -QtDir $QtDir -BuildDir $BuildDir -TestOnly
}

$exe = Join-Path $root "$BuildDir\bin\RentalCarSystem.exe"

if (-not (Test-Path $exe)) {
    throw "RentalCarSystem.exe не найден: $exe"
}

$packageName = "RentalCarSystem-windows-x64"
$stage = Join-Path $root "$OutputDir\$packageName"

if (Test-Path $stage) {
    Remove-Item $stage -Recurse -Force
}

New-Item -ItemType Directory -Force -Path $stage | Out-Null

Copy-Item $exe $stage

& $windeployqt --release --no-translations (Join-Path $stage "RentalCarSystem.exe")

if ($LASTEXITCODE -ne 0) {
    throw "windeployqt завершился с ошибкой."
}

if ($pgBin)
{
    $qsqlPluginSource = Join-Path $qtBin "..\plugins\sqldrivers\qsqlpsql.dll"
    $qsqlPluginTarget = Join-Path $stage "sqldrivers"

    New-Item -ItemType Directory -Force -Path $qsqlPluginTarget | Out-Null

    if (Test-Path $qsqlPluginSource) {
        Copy-Item $qsqlPluginSource $qsqlPluginTarget
    }

    foreach ($dll in @("libpq.dll", "libssl-3-x64.dll", "libcrypto-3-x64.dll", "libintl-9.dll", "libiconv-2.dll"))
    {
        $source = Join-Path $pgBin $dll

        if (Test-Path $source) {
            Copy-Item $source $stage
        }
    }
}

Copy-Item ".env.example" $stage
Copy-Item "README.md" $stage
Copy-Item "docs\BUILD_WINDOWS.md" $stage
Copy-Item "database" $stage -Recurse

if (-not $NoArchive)
{
    $zip = Join-Path $root "$OutputDir\$packageName.zip"

    if (Test-Path $zip) {
        Remove-Item $zip -Force
    }

    Compress-Archive -Path "$stage\*" -DestinationPath $zip

    Write-Host "Комплект создан: $zip" -ForegroundColor Green
}
else
{
    Write-Host "Каталог комплекта: $stage" -ForegroundColor Green
}
