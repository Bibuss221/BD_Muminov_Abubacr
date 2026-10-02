# Build and run RentalCarSystem.
#
# The script detects Qt, MinGW, CMake, Ninja and PostgreSQL.
# Use -QtDir when Qt is installed in a non-standard location.

param(
    [string]$QtDir,
    [string]$BuildDir = "build",
    [string]$BuildType = "Release",
    [switch]$Configure,
    [switch]$TestOnly
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

function Find-Newest([string]$pattern)
{
    if ($pattern -notmatch '[\\*\\?]') {
        if (Test-Path $pattern) {
            return (Resolve-Path $pattern).Path
        }

        return $null
    }

    $found = Get-ChildItem $pattern -Directory -ErrorAction SilentlyContinue |
        Sort-Object Name -Descending

    if ($found) {
        return $found[0].FullName
    }

    return $null
}

if (-not $QtDir) {
    $QtDir = Find-Newest "C:\\Qt\6.*\mingw_64"
}

if (-not $QtDir) {
    throw "Qt was not found. Pass the path with -QtDir."
}

$mingwDir = Find-Newest "C:\\Qt\Tools\mingw*_64"
$cmakeDir = Find-Newest "C:\\Qt\Tools\CMake_64"
$ninjaDir = Find-Newest "C:\\Qt\Tools\Ninja"
$pgDir = Find-Newest "C:\\Program Files\PostgreSQL\*\bin"

$pathEntries = @("$QtDir\bin")

if ($mingwDir) {
    $pathEntries += "$mingwDir\bin"
}

if ($cmakeDir) {
    $pathEntries += "$cmakeDir\bin"
}

if ($ninjaDir) {
    $pathEntries += $ninjaDir
}

if ($pgDir) {
    $pathEntries += $pgDir
}

$env:PATH = ($pathEntries -join ";") + ";" + $env:PATH

foreach ($tool in @("cmake", "ninja", "g++")) {
    if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
        throw "Required tool was not found: $tool"
    }
}

Write-Host "Qt: $QtDir" -ForegroundColor DarkGray

if ($pgDir) {
    Write-Host "PostgreSQL: $pgDir" -ForegroundColor DarkGray
}

if ($Configure -or -not (Test-Path "$BuildDir\CMakeCache.txt")) {
    Write-Host "[1/3] Configure" -ForegroundColor Cyan

    cmake -S . -B $BuildDir -G Ninja "-DCMAKE_BUILD_TYPE=$BuildType" "-DCMAKE_PREFIX_PATH=$QtDir"

    if ($LASTEXITCODE -ne 0) {
        throw "CMake configure failed."
    }
}
else {
    Write-Host "[1/3] Configure skipped." -ForegroundColor DarkGray
}

Write-Host "[2/3] Build" -ForegroundColor Cyan

cmake --build $BuildDir

if ($LASTEXITCODE -ne 0) {
    throw "Build failed."
}

Write-Host "[3/3] Tests" -ForegroundColor Cyan

ctest --test-dir $BuildDir --output-on-failure

if ($LASTEXITCODE -ne 0) {
    throw "Tests failed."
}

if ($TestOnly) {
    Write-Host "TestOnly mode: application launch skipped." -ForegroundColor Yellow
    exit 0
}

$exe = Join-Path $root "$BuildDir\bin\RentalCarSystem.exe"

if (-not (Test-Path $exe)) {
    throw "Executable was not found: $exe"
}

Write-Host "Launching RentalCarSystem..." -ForegroundColor Green
& $exe
