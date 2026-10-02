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
 стоимость NUMERIC(12,2) NOT NULL CHECK (стоимость > 0),
 год_выпуска INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS Сделка (
 id_сделки SERIAL PRIMARY KEY,
 id_клиента INTEGER NOT NULL REFERENCES Клиент(id_клиента),
 гос_номер VARCHAR(15) NOT NULL REFERENCES Автомобиль(гос_номер),
 дата_выдачи DATE NOT NULL,
 ожидаемая_дата_возврата DATE NOT NULL,
 фактическая_дата_возврата DATE,
 стоимость_проката NUMERIC(12,2) NOT NULL CHECK (стоимость_проката > 0),
 CHECK (ожидаемая_дата_возврата >= дата_выдачи)
);
CREATE TABLE IF NOT EXISTS Скидка (
 id_скидки SERIAL PRIMARY KEY,
 размер_скидки NUMERIC(5,2) NOT NULL CHECK (размер_скидки BETWEEN 0 AND 100),
 условие VARCHAR(200) NOT NULL
);
CREATE TABLE IF NOT EXISTS Штраф (
 id_штрафа SERIAL PRIMARY KEY,
 id_сделки INTEGER NOT NULL REFERENCES Сделка(id_сделки),
 вид_нарушения VARCHAR(200) NOT NULL,
 сумма_штрафа NUMERIC(12,2) NOT NULL CHECK (сумма_штрафа > 0)
);
CREATE TABLE IF NOT EXISTS Применение_скидки (
 id_сделки INTEGER NOT NULL REFERENCES Сделка(id_сделки),
 id_скидки INTEGER NOT NULL REFERENCES Скидка(id_скидки),
 PRIMARY KEY (id_сделки,id_скидки)
);
