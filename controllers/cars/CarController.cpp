#include "CarController.h"
#include "models/cars/CarRepository.h"
QSqlQueryModel* CarController::load(){return CarRepository().list();}
