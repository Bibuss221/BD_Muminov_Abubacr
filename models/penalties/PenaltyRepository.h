#pragma once

#include <QSqlQueryModel>

class PenaltyRepository
{
public:
    QSqlQueryModel* list();
};
