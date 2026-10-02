# Сборка и запуск Windows

## Требования

- Windows 10/11;
- PostgreSQL 14+ (в проверяемой конфигурации — PostgreSQL 18);
- Qt 6 с компонентами Widgets, Sql и Test;
- драйвер QPSQL (qsqlpsql.dll);
- MinGW из комплекта Qt;
- CMake 3.22+;
- Ninja.

## 1. Подготовка базы данных

В корне репозитория:

powershell -ExecutionPolicy Bypass -File scripts\setup_database.ps1

Скрипт сам ищет каталог PostgreSQL в C:\Program Files\PostgreSQL\*\bin.

После выполнения проверить:

psql -U postgres -d rental_cars_db

И в SQL Shell:

\dt
\dv

## 2. Сборка и тесты

Запуск одного скрипта:

powershell -ExecutionPolicy Bypass -File scripts\build_and_run.ps1

Если Qt установлен нестандартно:

powershell -ExecutionPolicy Bypass -File scripts\build_and_run.ps1 -QtDir C:\Qt\6.11.0\mingw_64

Только сборка и тесты без открытия окна:

powershell -ExecutionPolicy Bypass -File scripts\build_and_run.ps1 -TestOnly

Ручной вариант:

cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build
ctest --test-dir build --output-on-failure

Исполняемый файл:

build\bin\RentalCarSystem.exe

## 3. QPSQL

Если приложение пишет, что драйвер QPSQL не найден, проверь:

Qt\6.x.x\mingw_64\plugins\sqldrivers\qsqlpsql.dll

На Windows QPSQL также использует клиентскую библиотеку PostgreSQL libpq.dll. Скрипт сборки добавляет PostgreSQL/bin в PATH, если каталог найден автоматически.

## 4. Проверка связи приложения с БД

После подключения главное окно показывает сведения о БД в строке состояния.

Кнопка «Проверить БД» выполняет SQL:

SELECT 1;

Ожидаемый ответ:

Ответ БД: SELECT 1 → 1

Это реальный результат PostgreSQL, полученный через Qt SQL.

## 5. Проверка бизнес-правил

В SQL Shell:

\i tests/database_business_rules.sql

Тест проверяет корректную сделку, запрет пересечения периодов одной машины и запрет неправильной даты возврата.

Ожидаемые ошибки сохраняются внутри SAVEPOINT, поэтому тестовый сценарий продолжает выполняться и затем делает ROLLBACK.

## 6. Оптимизация

Запустить:

psql -U postgres -d rental_cars_db -f database\optimization.sql

Скрипт содержит EXPLAIN (ANALYZE, BUFFERS) для основных поисковых запросов.

## 7. Резервное копирование

Создание дампа:

powershell -ExecutionPolicy Bypass -File scripts\backup_database.ps1

По умолчанию файл появится в каталоге backups.

Восстановление:

powershell -ExecutionPolicy Bypass -File scripts\restore_database.ps1 -BackupFile .\backups\rental_cars_YYYYMMDD_HHMMSS.dump

## 8. Переносимый комплект

Для подготовки ZIP:

powershell -ExecutionPolicy Bypass -File scripts\package_windows.ps1

Скрипт собирает Release, запускает тесты, использует windeployqt, копирует QPSQL и PostgreSQL client DLL и создаёт архив.

Результат:

dist\RentalCarSystem-windows-x64.zip

Настоящий .env в архив не включается.