param(
    [string]$OutputDirectory = "backups",
    [string]$Database = "rental_cars_db"
)

$ErrorActionPreference = "Stop"

New-Item -ItemType Directory -Force -Path $OutputDirectory | Out-Null

$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$output = Join-Path $OutputDirectory "rental_cars_$stamp.dump"

pg_dump -U postgres -d $Database -Fc -f $output

Write-Host "Резервная копия создана: $output"
