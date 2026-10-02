#include "ReportRepository.h"

#include "../database/DatabaseManager.h"

QSqlQueryModel* ReportRepository::carSummary()
{
    auto* model = new QSqlQueryModel;

    model->setQuery(
        "SELECT гос_номер, марка, тип, rent_count, total_revenue "
        "FROM v_car_rent_summary "
        "ORDER BY rent_count DESC",
        DatabaseManager::instance().database());

    return model;
}
