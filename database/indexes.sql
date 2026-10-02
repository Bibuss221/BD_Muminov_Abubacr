CREATE INDEX IF NOT EXISTS idx_client_phone ON Клиент(номер_телефона);
CREATE INDEX IF NOT EXISTS idx_deal_client ON Сделка(id_клиента);
CREATE INDEX IF NOT EXISTS idx_deal_car ON Сделка(гос_номер);
CREATE INDEX IF NOT EXISTS idx_deal_dates ON Сделка(дата_выдачи,ожидаемая_дата_возврата);
