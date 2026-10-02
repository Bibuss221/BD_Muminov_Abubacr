$ErrorActionPreference='Stop'
psql -U postgres -d rental_cars_db -f database\drop.sql
powershell -ExecutionPolicy Bypass -File scripts\setup_database.ps1
