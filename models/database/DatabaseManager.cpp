#include "DatabaseManager.h"
DatabaseManager& DatabaseManager::instance(){static DatabaseManager m;return m;}
bool DatabaseManager::connect(const DbConfig& c){if(QSqlDatabase::contains("rental_connection")) QSqlDatabase::removeDatabase("rental_connection"); auto db=QSqlDatabase::addDatabase("QPSQL","rental_connection"); db.setHostName(c.host);db.setPort(c.port);db.setDatabaseName(c.database);db.setUserName(c.user);db.setPassword(c.password);return db.open();}
bool DatabaseManager::isOpen()const{return QSqlDatabase::contains("rental_connection")&&QSqlDatabase::database("rental_connection").isOpen();}
QSqlDatabase DatabaseManager::database()const{return QSqlDatabase::database("rental_connection");}
