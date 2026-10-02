#include "DatabaseManager.h"

#include <QSqlError>
#include <QSqlQuery>

DatabaseManager& DatabaseManager::instance()
{
    static DatabaseManager manager;
    return manager;
}

bool DatabaseManager::connect(const DbConfig& config)
{
    if (QSqlDatabase::contains("rental_connection")) {
        QSqlDatabase::database("rental_connection").close();
        QSqlDatabase::removeDatabase("rental_connection");
    }

    QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL", "rental_connection");
    db.setHostName(config.host);
    db.setPort(config.port);
    db.setDatabaseName(config.database);
    db.setUserName(config.user);
    db.setPassword(config.password);

    return db.open();
}

bool DatabaseManager::isOpen() const
{
    return QSqlDatabase::contains("rental_connection")
        && QSqlDatabase::database("rental_connection").isOpen();
}

QSqlDatabase DatabaseManager::database() const
{
    return QSqlDatabase::database("rental_connection");
}

QString DatabaseManager::connectionSummary() const
{
    if (!isOpen()) {
        return QStringLiteral("PostgreSQL: не подключена");
    }

    QSqlQuery query(database());

    if (!query.exec(
            "SELECT current_database(), current_user, current_schema(), now()")) {
        return QStringLiteral("PostgreSQL: соединение есть, запрос не выполнен: %1")
            .arg(query.lastError().text());
    }

    if (!query.next()) {
        return QStringLiteral("PostgreSQL: соединение есть, ответ пустой");
    }

    return QStringLiteral("PostgreSQL: OK | БД: %1 | пользователь: %2 | схема: %3 | время сервера: %4")
        .arg(query.value(0).toString(),
             query.value(1).toString(),
             query.value(2).toString(),
             query.value(3).toDateTime().toString(Qt::ISODate));
}

bool DatabaseManager::ping(QString* response) const
{
    if (!isOpen()) {
        if (response) {
            *response = QStringLiteral("Нет открытого соединения с PostgreSQL.");
        }
        return false;
    }

    QSqlQuery query(database());

    if (!query.exec("SELECT 1")) {
        if (response) {
            *response = query.lastError().text();
        }
        return false;
    }

    if (!query.next()) {
        if (response) {
            *response = QStringLiteral("PostgreSQL не вернула строку.");
        }
        return false;
    }

    if (response) {
        *response = QStringLiteral("Ответ БД: SELECT 1 → %1").arg(query.value(0).toInt());
    }

    return true;
}
