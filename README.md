# Информационная система для организации проката автомобилей

Учебный репозиторий курсового проекта Муминова Абубакра Эмомназаровича, группа 251-951, по дисциплине «Проектирование и администрирование баз данных».

## Что находится в репозитории

Проект разделён на две связанные части:

- PostgreSQL — физическая модель, ограничения, триггеры, представление, индексы, роли и тестовые данные;
- C++/Qt — клиентское приложение для подключения к БД и просмотра результатов запросов.

Архитектурно исходный код организован по слоям Model / Controller / View по образцу репозитория Наумова. При этом предметная область, названия таблиц и серверная логика взяты из пояснительной записки Муминова.

## Текущее функциональное состояние

После сборки и подключения к PostgreSQL приложение:

1. открывает окно подключения;
2. устанавливает соединение через QPSQL;
3. показывает главное окно;
4. загружает данные клиентов, автомобилей и сделок из PostgreSQL;
5. показывает агрегированный отчёт по автомобилям;
6. выводит в строке состояния ответ от PostgreSQL;
7. кнопкой «Проверить БД» выполняет реальный запрос SELECT 1 и показывает ответ сервера.

Это сделано специально так, чтобы цепочка Qt → Model/Controller → PostgreSQL → Qt была видна прямо при демонстрации.

## Структура

BD_Muminov_Abubacr/
├── CMakeLists.txt
├── .env.example
├── README.md
├── LICENSE.md
├── app/
├── models/
│   ├── common/
│   ├── domain/
│   ├── database/
│   ├── auth/
│   ├── clients/
│   ├── cars/
│   ├── deals/
│   ├── discounts/
│   ├── penalties/
│   └── reports/
├── controllers/
│   ├── common/
│   ├── auth/
│   ├── clients/
│   ├── cars/
│   ├── deals/
│   ├── admin/
│   └── dashboard/
├── views/
│   ├── common/
│   ├── dialogs/
│   ├── auth/
│   ├── dashboard/
│   ├── clients/
│   ├── cars/
│   ├── deals/
│   ├── reports/
│   └── admin/
├── database/
│   ├── schema.sql
│   ├── triggers.sql
│   ├── views.sql
│   ├── indexes.sql
│   ├── optimization.sql
│   ├── roles.sql
│   ├── seed.sql
│   └── drop.sql
├── tests/
├── docs/
└── scripts/

## База данных

Основные отношения:

- Клиент;
- Автомобиль;
- Сделка;
- Скидка;
- Штраф;
- Применение_скидки.

Ключевые серверные правила:

- ожидаемая дата возврата не может быть раньше даты выдачи;
- фактическая дата возврата не может предшествовать дате выдачи;
- один автомобиль не может быть одновременно выдан двум клиентам на пересекающиеся периоды;
- стоимость сделки должна быть положительной.

## Связь с пояснительной запиской

Точная карта вынесена в docs/APPENDICES_TO_REPO.md.

Главное соответствие:

- Приложение А → database/schema.sql;
- Приложение Б → database/triggers.sql;
- Приложение В → database/roles.sql;
- v_car_rent_summary → database/views.sql;
- индексы → database/indexes.sql;
- EXPLAIN ANALYZE → database/optimization.sql;
- резервное копирование → scripts/backup_database.ps1.

## Развёртывание PostgreSQL

Из PowerShell в корне проекта:

powershell -ExecutionPolicy Bypass -File scripts\setup_database.ps1

Ручной порядок:

createdb -U postgres rental_cars_db
psql -U postgres -d rental_cars_db -f database\schema.sql
psql -U postgres -d rental_cars_db -f database\triggers.sql
psql -U postgres -d rental_cars_db -f database\views.sql
psql -U postgres -d rental_cars_db -f database\indexes.sql
psql -U postgres -d rental_cars_db -f database\roles.sql
psql -U postgres -d rental_cars_db -f database\seed.sql

## Сборка

Требуются PostgreSQL, Qt 6 с Widgets, Sql, Test и QPSQL, CMake 3.22+ и Ninja.

powershell -ExecutionPolicy Bypass -File scripts\build_and_run.ps1

Ручная сборка:

cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build
ctest --test-dir build --output-on-failure

## Проверка связи Qt с БД

После подключения в главном окне строка состояния показывает сведения о текущей БД, пользователе, схеме и времени сервера.

Кнопка «Проверить БД» выполняет SELECT 1 и показывает сообщение вида:

Ответ БД: SELECT 1 → 1

Это реальный ответ PostgreSQL, полученный через Qt SQL.

## Тестирование и обслуживание

- tests/database_business_rules.sql — проверка триггеров на реальной БД;
- database/optimization.sql — примеры EXPLAIN ANALYZE;
- scripts/backup_database.ps1 — создание дампа;
- scripts/restore_database.ps1 — восстановление из дампа;
- docs/VERIFICATION.md — чек-лист перед защитой.

## Диаграммы

Исходники UML/PlantUML лежат в docs/diagrams/. Там есть ER, Use Case, Sequence, архитектурная и классовая диаграммы.

## Автор

Муминов Абубакр Эмомназарович
Группа 251-951
Московский Политехнический Университет