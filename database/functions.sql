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
