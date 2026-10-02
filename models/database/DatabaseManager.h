#pragma once

#include <QSqlDatabase>
#include <QString>

#include "models/common/Config.h"

class DatabaseManager
{
public:
    static DatabaseManager& instance();

    bool connect(const DbConfig& config);
    bool isOpen() const;

    QSqlDatabase database() const;

    QString connectionSummary() const;
    bool ping(QString* response = nullptr) const;

private:
    DatabaseManager() = default;
};
