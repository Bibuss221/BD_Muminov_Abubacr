# Развёртывание PostgreSQL для курсового проекта.
#
# По умолчанию используется PostgreSQL 18, установленный в стандартный
# каталог Windows. Путь можно передать вручную через -PgBin.

param(
    [string]$PgBin,
    [string]$Database = "rental_cars_db"
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

if (-not $PgBin) {
    $PgBin = Find-Newest "C:Program FilesPostgreSQL*\bin"
}

if (-not $PgBin) {
    if (Get-Command psql -ErrorAction SilentlyContinue) {
        $PgBin = Split-Path (Get-Command psql).Source
    }
}

if (-not $PgBin) {
    throw "PostgreSQL не найден. Укажите -PgBin или добавьте PostgreSQL/bin в PATH."
}

$psql = Join-Path $PgBin "psql.exe"
$createdb = Join-Path $PgBin "createdb.exe"

if (-not (Test-Path $psql)) {
    throw "psql.exe не найден: $psql"
}

if (-not (Test-Path $createdb)) {
    throw "createdb.exe не найден: $createdb"
}

$env:PATH = "$PgBin;$($env:PATH)"

Write-Host "PostgreSQL: $PgBin" -ForegroundColor DarkGray
Write-Host "База: $Database" -ForegroundColor DarkGray

& $createdb -U postgres $Database 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "База уже существует, выполняется её полная пересборка." -ForegroundColor DarkGray
}

& $psql -U postgres -d $Database -v ON_ERROR_STOP=1 -f "$rootdatabaseull_database.sql"

if ($LASTEXITCODE -ne 0) {
    throw "Полный SQL-сценарий завершился с ошибкой."
}

Write-Host "База $Database готова. Загружены структура, серверная логика и демонстрационные данные." -ForegroundColor Green
