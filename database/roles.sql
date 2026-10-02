-- Ролевая модель из приложения В пояснительной записки.

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT FROM pg_roles WHERE rolname = 'employee_rental'
    ) THEN
        CREATE ROLE employee_rental NOLOGIN;
    END IF;

    IF NOT EXISTS (
        SELECT FROM pg_roles WHERE rolname = 'manager_org'
    ) THEN
        CREATE ROLE manager_org NOLOGIN;
    END IF;

    IF NOT EXISTS (
        SELECT FROM pg_roles WHERE rolname = 'db_admin'
    ) THEN
        CREATE ROLE db_admin NOLOGIN;
    END IF;
END
$$;

REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC;

GRANT SELECT, INSERT, UPDATE
    ON Клиент, Автомобиль, Сделка
    TO employee_rental;

GRANT SELECT, INSERT, UPDATE
    ON Скидка, Штраф, Применение_скидки
    TO employee_rental;

GRANT SELECT
    ON v_car_rent_summary
    TO manager_org;

GRANT SELECT
    ON Клиент, Автомобиль, Сделка, Скидка, Штраф
    TO manager_org;

GRANT ALL PRIVILEGES
    ON ALL TABLES IN SCHEMA public
    TO db_admin;

GRANT ALL PRIVILEGES
    ON ALL SEQUENCES IN SCHEMA public
    TO db_admin;
