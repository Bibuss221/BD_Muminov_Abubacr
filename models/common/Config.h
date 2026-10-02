#pragma once

#include <QString>

struct DbConfig
{
    QString host = QStringLiteral("localhost");
    int port = 5432;
    QString database = QStringLiteral("rental_cars_db");
    QString user = QStringLiteral("postgres");
    QString password;
};
