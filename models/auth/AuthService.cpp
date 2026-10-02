#include "AuthService.h"

#include "../database/DatabaseManager.h"

#include <QSqlQuery>

QString AuthService::currentUser() const
{
    QSqlQuery query(DatabaseManager::instance().database());

    if (!query.exec("SELECT current_user") || !query.next()) {
        return {};
    }

    return query.value(0).toString();
}
