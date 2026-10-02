#include "PenaltyRepository.h"

#include "../database/DatabaseManager.h"

QSqlQueryModel* PenaltyRepository::list()
{
    auto* model = new QSqlQueryModel;

    model->setQuery(
        "SELECT id_штрафа, id_сделки, вид_нарушения, сумма_штрафа "
        "FROM Штраф "
        "ORDER BY id_штрафа DESC",
        DatabaseManager::instance().database());

    return model;
}
