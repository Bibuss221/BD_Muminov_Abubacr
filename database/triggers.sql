CREATE OR REPLACE FUNCTION fn_check_car_availability() RETURNS TRIGGER AS $$ BEGIN IF EXISTS (SELECT 1 FROM Сделка s WHERE s.гос_номер=NEW.гос_номер AND s.id_сделки<>COALESCE(NEW.id_сделки,-1) AND NEW.дата_выдачи<=COALESCE(s.фактическая_дата_возврата,s.ожидаемая_дата_возврата) AND s.дата_выдачи<=NEW.ожидаемая_дата_возврата) THEN RAISE EXCEPTION 'Автомобиль занят в выбранный период'; END IF; RETURN NEW; END; $$ LANGUAGE plpgsql;
DROP TRIGGER IF EXISTS trg_check_car_availability ON Сделка;
CREATE TRIGGER trg_check_car_availability BEFORE INSERT OR UPDATE ON Сделка FOR EACH ROW EXECUTE FUNCTION fn_check_car_availability();
CREATE OR REPLACE FUNCTION fn_check_dates() RETURNS TRIGGER AS $$ BEGIN IF NEW.ожидаемая_дата_возврата<NEW.дата_выдачи THEN RAISE EXCEPTION 'Некорректный период проката'; END IF; IF NEW.фактическая_дата_возврата IS NOT NULL AND NEW.фактическая_дата_возврата<NEW.дата_выдачи THEN RAISE EXCEPTION 'Некорректная фактическая дата возврата'; END IF; RETURN NEW; END; $$ LANGUAGE plpgsql;
DROP TRIGGER IF EXISTS trg_check_dates ON Сделка;
CREATE TRIGGER trg_check_dates BEFORE INSERT OR UPDATE ON Сделка FOR EACH ROW EXECUTE FUNCTION fn_check_dates();
