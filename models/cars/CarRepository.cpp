#include "CarRepository.h"

#include "../database/DatabaseManager.h"

QSqlQueryModel* CarRepository::list()
{
    auto* model = new QSqlQueryModel;

    model->setQuery(
        "SELECT гос_номер, марка, тип, стоимость, год_выпуска "
        "FROM Автомобиль "
        "ORDER BY марка, гос_номер",
        DatabaseManager::instance().database());

    return model;
}
