#include "ClientRepository.h"
#include "../database/DatabaseManager.h"
QSqlQueryModel* ClientRepository::list(){auto*m=new QSqlQueryModel;m->setQuery("SELECT id_клиента,фамилия,имя,отчество,номер_телефона FROM Клиент ORDER BY фамилия",DatabaseManager::instance().database());return m;}
