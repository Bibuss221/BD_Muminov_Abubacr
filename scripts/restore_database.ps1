param(
    [Parameter(Mandatory = $true)]
    [string]$BackupFile,

    [string]$Database = "rental_cars_db"
)

$ErrorActionPreference = "Stop"

dropdb -U postgres --if-exists $Database
createdb -U postgres $Database
pg_restore -U postgres -d $Database --clean --if-exists $BackupFile

Write-Host "База восстановлена из: $BackupFile"
