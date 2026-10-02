#include "DealController.h"
#include "models/deals/DealRepository.h"
QSqlQueryModel* DealController::load(){return DealRepository().list();}
