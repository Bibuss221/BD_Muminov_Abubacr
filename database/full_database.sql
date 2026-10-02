-- Полная установка базы данных проекта «Прокат автомобилей».
-- Запуск:
-- psql -U postgres -d rental_cars_db -v ON_ERROR_STOP=1 -f database/full_database.sql
--
-- Скрипт пересоздаёт структуру и затем загружает демонстрационные данные.

DROP VIEW IF EXISTS v_car_rent_summary;

DROP TABLE IF EXISTS Применение_скидки CASCADE;
DROP TABLE IF EXISTS Штраф CASCADE;
DROP TABLE IF EXISTS Скидка CASCADE;
DROP TABLE IF EXISTS Сделка CASCADE;
DROP TABLE IF EXISTS Автомобиль CASCADE;
DROP TABLE IF EXISTS Клиент CASCADE;

-- Физическая модель из приложения А пояснительной записки.

CREATE TABLE IF NOT EXISTS Клиент (
    id_клиента SERIAL PRIMARY KEY,
    фамилия VARCHAR(50) NOT NULL,
    имя VARCHAR(50) NOT NULL,
    отчество VARCHAR(50),
    адрес VARCHAR(200) NOT NULL,
    номер_телефона VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Автомобиль (
    гос_номер VARCHAR(15) PRIMARY KEY,
    марка VARCHAR(50) NOT NULL,
    тип VARCHAR(50) NOT NULL,
    стоимость NUMERIC(12, 2) NOT NULL,
    год_выпуска INTEGER NOT NULL,

    CONSTRAINT chk_car_cost
        CHECK (стоимость > 0)
);

CREATE TABLE IF NOT EXISTS Сделка (
    id_сделки SERIAL PRIMARY KEY,
    id_клиента INTEGER NOT NULL
        REFERENCES Клиент (id_клиента),
    гос_номер VARCHAR(15) NOT NULL
        REFERENCES Автомобиль (гос_номер),
    дата_выдачи DATE NOT NULL,
    ожидаемая_дата_возврата DATE NOT NULL,
    фактическая_дата_возврата DATE,
    стоимость_проката NUMERIC(12, 2) NOT NULL,

    CONSTRAINT chk_dates
        CHECK (
            ожидаемая_дата_возврата >= дата_выдачи
            AND (
                фактическая_дата_возврата IS NULL
                OR фактическая_дата_возврата >= дата_выдачи
            )
        ),

    CONSTRAINT chk_rent_cost
        CHECK (стоимость_проката > 0)
);

CREATE TABLE IF NOT EXISTS Скидка (
    id_скидки SERIAL PRIMARY KEY,
    размер_скидки NUMERIC(5, 2) NOT NULL,
    условие VARCHAR(200) NOT NULL,

    CONSTRAINT chk_discount_percent
        CHECK (размер_скидки BETWEEN 0 AND 100)
);

CREATE TABLE IF NOT EXISTS Штраф (
    id_штрафа SERIAL PRIMARY KEY,
    id_сделки INTEGER NOT NULL
        REFERENCES Сделка (id_сделки),
    вид_нарушения VARCHAR(200) NOT NULL,
    сумма_штрафа NUMERIC(12, 2) NOT NULL,

    CONSTRAINT chk_penalty_amount
        CHECK (сумма_штрафа > 0)
);

CREATE TABLE IF NOT EXISTS Применение_скидки (
    id_сделки INTEGER NOT NULL
        REFERENCES Сделка (id_сделки),
    id_скидки INTEGER NOT NULL
        REFERENCES Скидка (id_скидки),

    PRIMARY KEY (id_сделки, id_скидки)
);


-- Серверная бизнес-логика из приложения Б к пояснительной записке.

CREATE OR REPLACE FUNCTION fn_check_car_availability()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Сделка AS s
        WHERE s.гос_номер = NEW.гос_номер
          AND s.id_сделки <> COALESCE(NEW.id_сделки, -1)
          AND NEW.дата_выдачи <= COALESCE(
              s.фактическая_дата_возврата,
              s.ожидаемая_дата_возврата
          )
          AND s.дата_выдачи <= NEW.ожидаемая_дата_возврата
    ) THEN
        RAISE EXCEPTION 'Автомобиль занят в выбранный период';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_car_availability ON Сделка;

CREATE TRIGGER trg_check_car_availability
BEFORE INSERT OR UPDATE ON Сделка
FOR EACH ROW
EXECUTE FUNCTION fn_check_car_availability();


CREATE OR REPLACE FUNCTION fn_check_dates()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.ожидаемая_дата_возврата < NEW.дата_выдачи THEN
        RAISE EXCEPTION 'Некорректный период проката';
    END IF;

    IF NEW.фактическая_дата_возврата IS NOT NULL
       AND NEW.фактическая_дата_возврата < NEW.дата_выдачи THEN
        RAISE EXCEPTION 'Некорректная фактическая дата возврата';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_check_dates ON Сделка;

CREATE TRIGGER trg_check_dates
BEFORE INSERT OR UPDATE ON Сделка
FOR EACH ROW
EXECUTE FUNCTION fn_check_dates();


-- Серверная функция расчёта стоимости сделки.
-- Формула соответствует подразделу 2.5.3 пояснительной записки:
-- базовая стоимость за день × количество дней × (1 - скидка / 100).

CREATE OR REPLACE FUNCTION fn_calc_rent_cost(
    p_base_cost NUMERIC,
    p_days INTEGER,
    p_discount NUMERIC DEFAULT 0
)
RETURNS NUMERIC AS $$
BEGIN
    IF p_base_cost <= 0 THEN
        RAISE EXCEPTION 'Базовая стоимость должна быть положительной';
    END IF;

    IF p_days <= 0 THEN
        RAISE EXCEPTION 'Количество дней должно быть положительным';
    END IF;

    IF p_discount < 0 OR p_discount > 100 THEN
        RAISE EXCEPTION 'Размер скидки должен быть от 0 до 100 процентов';
    END IF;

    RETURN ROUND(
        p_base_cost * p_days * (1 - p_discount / 100),
        2
    );
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE VIEW v_car_rent_summary AS
SELECT
    a.гос_номер,
    a.марка,
    a.тип,
    COUNT(s.id_сделки) AS rent_count,
    COALESCE(SUM(s.стоимость_проката), 0) AS total_revenue
FROM Автомобиль AS a
LEFT JOIN Сделка AS s
    ON s.гос_номер = a.гос_номер
GROUP BY
    a.гос_номер,
    a.марка,
    a.тип;


-- Индексы из подраздела 2.5.8 пояснительной записки.

CREATE INDEX IF NOT EXISTS idx_client_phone
    ON Клиент (номер_телефона);

CREATE INDEX IF NOT EXISTS idx_deal_client
    ON Сделка (id_клиента);

CREATE INDEX IF NOT EXISTS idx_deal_car
    ON Сделка (гос_номер);

CREATE INDEX IF NOT EXISTS idx_deal_dates
    ON Сделка (дата_выдачи, ожидаемая_дата_возврата);


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
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM PUBLIC;

GRANT SELECT, INSERT, UPDATE
    ON Клиент, Автомобиль, Сделка
    TO employee_rental;

GRANT SELECT, INSERT, UPDATE
    ON Скидка, Штраф, Применение_скидки
    TO employee_rental;

-- SERIAL-поля используют sequences. Без USAGE роль не сможет вставлять
-- новые строки в таблицы с автоматически выдаваемым идентификатором.
GRANT USAGE, SELECT
    ON ALL SEQUENCES IN SCHEMA public
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


-- Демонстрационные данные для курсового проекта.
-- Заполнение выполняется средствами PostgreSQL, без ручного перечисления
-- сотен строк. После запуска получаются 500 клиентов, 500 автомобилей,
-- 500 скидок, 750 сделок, 750 применений скидок и 500 штрафов.

BEGIN;

TRUNCATE TABLE
    Применение_скидки,
    Штраф,
    Сделка,
    Скидка,
    Автомобиль,
    Клиент
RESTART IDENTITY CASCADE;

INSERT INTO Клиент (
    фамилия, имя, отчество, адрес, номер_телефона
)
SELECT
    фамилии[((g.n - 1) % array_length(фамилии, 1)) + 1],
    имена[((g.n - 1) % array_length(имена, 1)) + 1],
    отчества[((g.n - 1) % array_length(отчества, 1)) + 1],
    format(
        'Москва, ул. %s, д. %s',
        улицы[((g.n - 1) % array_length(улицы, 1)) + 1],
        ((g.n - 1) % 90) + 1
    ),
    '+7999' || lpad(g.n::text, 7, '0')
FROM generate_series(1, 500) AS g(n)
CROSS JOIN (
    SELECT
        ARRAY[
            'Иванов','Петров','Сидоров','Кузнецов','Смирнов',
            'Попов','Васильев','Морозов','Новиков','Фёдоров'
        ] AS фамилии,
        ARRAY[
            'Иван','Анна','Максим','Мария','Дмитрий',
            'Елена','Артём','Ольга','Александр','Полина'
        ] AS имена,
        ARRAY[
            'Иванович','Сергеевна','Олегович','Андреевна','Ильич',
            'Павловна','Викторович','Николаевна','Алексеевич','Дмитриевна'
        ] AS отчества,
        ARRAY[
            'Ленина','Тверская','Мира','Академическая','Новая',
            'Южная','Полевая','Садовая','Школьная','Центральная'
        ] AS улицы
) AS d;

INSERT INTO Автомобиль (
    гос_номер, марка, тип, стоимость, год_выпуска
)
SELECT
    'А' || lpad(g.n::text, 3, '0') || 'АА777',
    марки[((g.n - 1) % array_length(марки, 1)) + 1],
    типы[((g.n - 1) % array_length(типы, 1)) + 1],
    2200 + ((g.n * 137) % 3000),
    2020 + ((g.n - 1) % 6)
FROM generate_series(1, 500) AS g(n)
CROSS JOIN (
    SELECT
        ARRAY[
            'Toyota Camry','Kia Rio','Hyundai Creta','Skoda Octavia',
            'Haval F7','Lada Vesta','Volkswagen Tiguan','Renault Duster',
            'BMW 3 Series','Mercedes-Benz C-Class'
        ] AS марки,
        ARRAY[
            'Седан','Седан','Кроссовер','Седан','Кроссовер',
            'Седан','Кроссовер','Кроссовер','Седан','Седан'
        ] AS типы
) AS d;

INSERT INTO Скидка (
    размер_скидки, условие
)
SELECT
    5 + ((g.n - 1) % 16),
    CASE ((g.n - 1) % 5)
        WHEN 0 THEN 'Постоянный клиент'
        WHEN 1 THEN 'Аренда более 7 дней'
        WHEN 2 THEN 'Сезонная акция'
        WHEN 3 THEN 'Повторная аренда'
        ELSE 'Специальное предложение'
    END || ' №' || g.n
FROM generate_series(1, 500) AS g(n);

INSERT INTO Сделка (
    id_клиента,
    гос_номер,
    дата_выдачи,
    ожидаемая_дата_возврата,
    фактическая_дата_возврата,
    стоимость_проката
)
SELECT
    g.n - ((g.n - 1) / 500) * 500,
    'А' || lpad((g.n - ((g.n - 1) / 500) * 500)::text, 3, '0') || 'АА777',
    DATE '2026-01-01'
        + (((g.n - 1) / 500) * 365)
        + ((g.n - 1) % 180),
    DATE '2026-01-01'
        + (((g.n - 1) / 500) * 365)
        + ((g.n - 1) % 180)
        + 2
        + ((g.n - 1) % 5),
    CASE
        WHEN g.n % 7 = 0 THEN NULL
        WHEN g.n % 5 = 0 THEN
            DATE '2026-01-01'
                + (((g.n - 1) / 500) * 365)
                + ((g.n - 1) % 180)
                + 3
                + ((g.n - 1) % 5)
        ELSE
            DATE '2026-01-01'
                + (((g.n - 1) / 500) * 365)
                + ((g.n - 1) % 180)
                + 2
                + ((g.n - 1) % 5)
    END,
    ROUND(
        (2200 + ((((g.n - 1) % 500 + 1) * 137) % 3000))
        * (3 + ((g.n - 1) % 5)),
        2
    )
FROM generate_series(1, 750) AS g(n);

INSERT INTO Применение_скидки (
    id_сделки, id_скидки
)
SELECT
    s.id_сделки,
    ((s.id_сделки - 1) % 500) + 1
FROM Сделка AS s
ORDER BY s.id_сделки;

INSERT INTO Штраф (
    id_сделки, вид_нарушения, сумма_штрафа
)
SELECT
    s.id_сделки,
    CASE ((s.id_сделки - 1) % 5)
        WHEN 0 THEN 'Возврат автомобиля с повреждением'
        WHEN 1 THEN 'Загрязнение салона'
        WHEN 2 THEN 'Просрочка возврата'
        WHEN 3 THEN 'Нарушение условий договора'
        ELSE 'Недостающий комплект оборудования'
    END,
    1500 + ((s.id_сделки * 83) % 12000)
FROM Сделка AS s
WHERE s.id_сделки <= 500
ORDER BY s.id_сделки;

ANALYZE;

COMMIT;

