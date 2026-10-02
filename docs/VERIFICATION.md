# Что проверить перед сдачей

## 1. PostgreSQL

После запуска `scripts/setup_database.ps1`:

```sql
\c rental_cars_db
\dt
\dv
```

Проверить:

- таблицы клиентов, автомобилей, сделок, скидок, штрафов;
- представление `v_car_rent_summary`;
- индексы `idx_client_phone` и `idx_deal_client`;
- роли `employee_rental`, `manager_org`, `db_admin`.

## 2. Qt

После запуска приложения:

1. окно подключения принимает Host, Database, User, Password;
2. после подключения появляется главное окно;
3. строка состояния показывает ответ PostgreSQL;
4. кнопка «Проверить БД» выполняет `SELECT 1`;
5. вкладки Клиенты, Автомобили, Сделки и Отчёт получают данные непосредственно из PostgreSQL.

## 3. Бизнес-правила

В SQL Shell выполнить `tests/database_business_rules.sql`.

Пересечение аренды должно быть отклонено триггером, а некорректная дата возврата — серверной проверкой.

## 4. Оптимизация

Выполнить `database/optimization.sql` и сохранить вывод `EXPLAIN ANALYZE` в отчёт или папку `docs/screenshots`.

## 5. Резервная копия

В PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\backup_database.ps1
```

После этого в `backups/` должен появиться файл `.dump`.
