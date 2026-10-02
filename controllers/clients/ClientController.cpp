#include "ClientController.h"
#include "models/clients/ClientRepository.h"
QSqlQueryModel* ClientController::load(){return ClientRepository().list();}
