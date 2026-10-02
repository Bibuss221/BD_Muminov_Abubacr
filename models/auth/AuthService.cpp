#include "AuthService.h"
#include "../database/DatabaseManager.h"
#include <QSqlQuery>
QString AuthService::currentUser()const{QSqlQuery q(DatabaseManager::instance().database());if(q.exec("SELECT current_user")&&q.next())return q.value(0).toString();return {};}
