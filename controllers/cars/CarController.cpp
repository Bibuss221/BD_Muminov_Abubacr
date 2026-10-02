#include "CarController.h"

#include "models/cars/CarRepository.h"

QSqlQueryModel* CarController::load() const
{
    return CarRepository().list();
}
