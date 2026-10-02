#include "ClientController.h"

#include "models/clients/ClientRepository.h"

QSqlQueryModel* ClientController::load() const
{
    return ClientRepository().list();
}
