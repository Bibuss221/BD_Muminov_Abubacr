#include "ClientRepository.h"

#include "../database/DatabaseManager.h"

QSqlQueryModel* ClientRepository::list()
{
    auto* model = new QSqlQueryModel;

    model->setQuery(
        "SELECT id_клиента, фамилия, имя, отчество, номер_телефона "
        "FROM Клиент "
        "ORDER BY фамилия, имя",
        DatabaseManager::instance().database());

    return model;
}
