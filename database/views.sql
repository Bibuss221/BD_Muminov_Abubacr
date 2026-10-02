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
