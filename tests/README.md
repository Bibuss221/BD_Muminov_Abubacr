# Тесты

В каталоге находятся два уровня проверки.

## Qt Test

`test_date_rules.cpp`, `test_overlap_rules.cpp`, `test_validation.cpp` проверяют серверно-независимые правила.

## PostgreSQL

`database_business_rules.sql` проверяет триггеры на реальной БД.

Запуск Qt Test:

```powershell
ctest --test-dir build --output-on-failure
```
