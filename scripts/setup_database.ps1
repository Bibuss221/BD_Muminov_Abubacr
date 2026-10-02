$ErrorActionPreference='Stop'
$root=Split-Path -Parent $PSScriptRoot
psql -U postgres -c "CREATE DATABASE rental_cars_db" 2>$null
psql -U postgres -d rental_cars_db -f "$root\database\schema.sql"
psql -U postgres -d rental_cars_db -f "$root\database\triggers.sql"
psql -U postgres -d rental_cars_db -f "$root\database\views.sql"
psql -U postgres -d rental_cars_db -f "$root\database\indexes.sql"
psql -U postgres -d rental_cars_db -f "$root\database\roles.sql"
psql -U postgres -d rental_cars_db -f "$root\database\seed.sql"
Write-Host 'rental_cars_db готова'
