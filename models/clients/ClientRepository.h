#pragma once

#include <QSqlQueryModel>

class ClientRepository
{
public:
    QSqlQueryModel* list();
};
