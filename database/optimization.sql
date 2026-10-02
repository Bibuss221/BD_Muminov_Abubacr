-- Проверка индексов через EXPLAIN ANALYZE.
-- Сценарий соответствует разделу 2.5.8 пояснительной записки.

EXPLAIN (ANALYZE, BUFFERS)
SELECT id_клиента, фамилия, имя, номер_телефона
FROM Клиент
WHERE номер_телефона = '+79990000001';

EXPLAIN (ANALYZE, BUFFERS)
SELECT id_сделки, гос_номер, дата_выдачи, ожидаемая_дата_возврата
FROM Сделка
WHERE id_клиента = 1
ORDER BY дата_выдачи DESC;

EXPLAIN (ANALYZE, BUFFERS)
SELECT гос_номер, марка, тип, rent_count, total_revenue
FROM v_car_rent_summary
ORDER BY rent_count DESC;
