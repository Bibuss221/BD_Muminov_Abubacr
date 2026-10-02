# Информационная система для организации проката автомобилей

Учебный репозиторий курсового проекта Муминова Абубакра Эмомназаровича,
группа 251-951, по дисциплине «Проектирование и администрирование баз данных».

Проект повторяет организацию репозитория Наумова: отдельные каталоги для приложения,
моделей, контроллеров, представлений, базы данных, тестов, документации и скриптов.
Предметная область заменена на прокат автомобилей, а SQL-часть опирается на код
из приложения к пояснительной записке Муминова.

## Что есть в проекте

- PostgreSQL: таблицы `Клиент`, `Автомобиль`, `Сделка`, `Скидка`, `Штраф`,
  `Применение_скидки`;
- первичные и внешние ключи, `NOT NULL`, `UNIQUE`, `CHECK`;
- триггер проверки пересечения периодов аренды;
- триггер проверки дат;
- представление `v_car_rent_summary`;
- индексы по часто используемым полям;
- роли PostgreSQL `employee_rental`, `manager_org`, `db_admin`;
- демонстрационные логины для запуска с нуля;
- Qt 6 Widgets + Qt Sql + C++17;
- разделение `models / controllers / views`;
- экран подключения и определения роли;
- таблицы клиентов, автомобилей, сделок и отчёта;
- автоматическое обновление данных;
- минимальные Qt Test для правил периода аренды.

## Структура

```text
kursovoi_bd_muminov/
├── CMakeLists.txt
├── .env.example
├── .gitignore
├── README.md
│
├── app/
│   ├── main.cpp
│   └── resources/
│       └── style.qss
│
├── models/
│   ├── common/
│   │   └── DateRules.h
│   ├── database/
│   │   ├── DatabaseManager.h
│   │   └── DatabaseManager.cpp
│   └── rental/
│       └── RentalModels.h
│
├── controllers/
│   ├── AuthController.h
│   ├── AuthController.cpp
│   ├── RentalController.h
│   └── RentalController.cpp
│
├── views/
│   ├── LoginWindow.h
│   ├── LoginWindow.cpp
│   ├── MainWindow.h
│   └── MainWindow.cpp
│
├── database/
│   ├── schema.sql
│   ├── triggers.sql
│   ├── views.sql
│   ├── indexes.sql
│   ├── roles.sql
│   ├── seed.sql
│   └── drop.sql
│
├── tests/
│   ├── CMakeLists.txt
│   └── test_date_rules.cpp
│
├── docs/
│   ├── BUILD_WINDOWS.md
│   ├── PZ_TO_REPO.md
│   ├── database/
│   │   └── database_description.md
│   └── diagrams/
│       ├── use_case.puml
│       ├── er_model.puml
│       └── sequence.puml
│
└── scripts/
    ├── setup_database.ps1
    ├── reset_database.ps1
    └── build_and_run.ps1
```

## 1. Что установить

Для полноценной сборки Windows нужны:

1. PostgreSQL 14+.
2. Qt 6 с компонентами:
   - Qt Widgets;
   - Qt Sql;
   - Qt Test;
   - драйвер QPSQL.
3. CMake 3.22+.
4. Ninja.
5. MinGW из комплекта Qt.

## 2. Создание базы данных с нуля

Открой PowerShell в корне проекта:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\setup_database.ps1
```

Скрипт создаёт базу `rental_cars_db`, таблицы, триггеры, представление,
индексы, роли и демонстрационные данные.

Для ручного выполнения:

```powershell
createdb -U postgres rental_cars_db
psql -U postgres -d rental_cars_db -f database\schema.sql
psql -U postgres -d rental_cars_db -f database\triggers.sql
psql -U postgres -d rental_cars_db -f database\views.sql
psql -U postgres -d rental_cars_db -f database\indexes.sql
psql -U postgres -d rental_cars_db -f database\roles.sql
psql -U postgres -d rental_cars_db -f database\seed.sql
```

## 3. Демонстрационные подключения

Скрипт создаёт три роли для демонстрации.

| Логин | Пароль | Роль |
|---|---|---|
| `rental_employee` | `Employee#2026` | `employee_rental` |
| `rental_manager` | `Manager#2026` | `manager_org` |
| `rental_admin` | `Admin#2026` | `db_admin` |

Это учебные пароли. В реальной системе их необходимо заменить.

## 4. Сборка

Автоматически:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\build_and_run.ps1
```

Вручную:

```powershell
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build
```

## 5. Запуск

```powershell
.\build\bin\RentalCarSystem.exe
```

В окне подключения можно указать:

```text
Host: localhost
Port: 5432
Database: rental_cars_db
User: rental_employee
Password: Employee#2026
```

После подключения приложение определяет роль через PostgreSQL и включает
соответствующий режим.

## 6. Что проверять на защите

Главная цепочка проекта:

```text
Клиент
  ↓
Автомобиль
  ↓
Сделка
  ↓
Скидка / Применение_скидки
  ↓
Штраф
```

Ключевое серверное правило:

> один автомобиль не может быть одновременно выдан двум клиентам
> на пересекающиеся периоды.

Это реализовано триггером `trg_check_car_availability`.

Ещё одно правило:

> ожидаемая дата возврата не может быть раньше даты выдачи,
> а фактическая дата возврата не может быть раньше даты выдачи.

Это реализовано ограничением и триггером `trg_check_dates`.

## 7. Сопоставление с пояснительной запиской

SQL-часть не придумана вместо твоей работы: она основана на приложениях к твоей
пояснительной записке. В частности, там приведены таблицы, функции
`fn_check_car_availability()` / `fn_check_dates()`, роли и права доступа,
представление `v_car_rent_summary` и индексы `idx_client_phone` / `idx_deal_client`.

Архитектура C++/Qt добавлена как отдельная прикладная оболочка, чтобы репозиторий
был полноценным запускаемым проектом по образцу репозитория Наумова.
