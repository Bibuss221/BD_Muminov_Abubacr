#include "RepositoryBase.h"
#include "DatabaseManager.h"
QSqlQuery RepositoryBase::query()const{return QSqlQuery(DatabaseManager::instance().database());}
