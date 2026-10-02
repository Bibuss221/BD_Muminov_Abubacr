#include "DealRepository.h"

#include "../database/DatabaseManager.h"

QSqlQueryModel* DealRepository::list()
{
    auto* model = new QSqlQueryModel;

    model->setQuery(
        "SELECT id_сделки, id_клиента, гос_номер, "
        "дата_выдачи, ожидаемая_дата_возврата, "
        "фактическая_дата_возврата, стоимость_проката "
        "FROM Сделка "
        "ORDER BY дата_выдачи DESC, id_сделки DESC",
        DatabaseManager::instance().database());

    return model;
}
