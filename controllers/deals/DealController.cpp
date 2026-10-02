#include "DealController.h"

#include "models/deals/DealRepository.h"

QSqlQueryModel* DealController::load() const
{
    return DealRepository().list();
}
