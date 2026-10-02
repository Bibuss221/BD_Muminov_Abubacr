# Информационная система для организации проката автомобилей

Учебный репозиторий курсового проекта Муминова Абубакра Эмомназаровича, группа 251-951, по дисциплине «Проектирование и администрирование баз данных».

## Назначение

Настольное приложение для работы организации проката автомобилей: учёт клиентов, автомобилей, сделок аренды, скидок и штрафов, а также отчётность.

Проект построен по той же общей архитектурной идее, что и репозиторий Наумова: отдельные слои Model / Controller / View, самостоятельный каталог PostgreSQL, тесты, документация, диаграммы и PowerShell-скрипты. Предметная область и SQL-логика относятся именно к проекту Муминова.

## Возможности

- клиенты: просмотр, поиск, добавление и изменение;
- автомобили: просмотр и добавление;
- сделки: оформление и просмотр истории аренды;
- серверная проверка пересечения периодов аренды;
- серверная проверка корректности дат;
- скидки и штрафы;
- представление v_car_rent_summary;
- индексы idx_client_phone и idx_deal_client;
- роли PostgreSQL employee_rental, manager_org, db_admin;
- Qt 6 Widgets + Qt Sql + C++17;
- разделение проекта на models, controllers, views;
- Qt Test;
- PlantUML/Mermaid-диаграммы;
- PowerShell-скрипты развёртывания и сборки.

## Архитектура

PostgreSQL <- models <- controllers <- views <- app

Model содержит сущности и репозитории, Controller организует сценарии, View содержит Qt Widgets, app содержит точку входа.

## Структура

BD_Muminov_Abubacr/
├── CMakeLists.txt
├── .env.example
├── README.md
├── LICENSE.md
├── app/
├── models/
├── controllers/
├── views/
├── database/
├── tests/
├── docs/
└── scripts/

Внутри models/controllers/views каталоги дополнительно разделены по предметным подсистемам.

## База данных

Основные отношения: Клиент, Автомобиль, Сделка, Скидка, Штраф, Применение_скидки.

SQL-часть основана на коде из приложения к пояснительной записке: таблицы, триггер доступности автомобиля, триггер дат, роли, представление и индексы вынесены в отдельные файлы.

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

## Сборка Windows

Требуются PostgreSQL, Qt 6 с Widgets, Sql, Test и QPSQL, CMake 3.22+ и Ninja.

powershell -ExecutionPolicy Bypass -File scripts\build_and_run.ps1

Ручная сборка:

cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build

## Тесты

ctest --test-dir build --output-on-failure

## Документация

docs/ARCHITECTURE.md — устройство приложения.
docs/database/ — структура БД и связь с пояснительной запиской.
docs/diagrams/ — ER, Use Case, Sequence и архитектурная диаграммы.
docs/report/ — пояснительная записка.
docs/screenshots/ — скриншоты работающего приложения.

## Автор

Муминов Абубакр Эмомназарович
Группа 251-951
Московский Политехнический Университет
