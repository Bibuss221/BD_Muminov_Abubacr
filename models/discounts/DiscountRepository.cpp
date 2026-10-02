#include "DiscountRepository.h"
#include "../database/DatabaseManager.h"
QSqlQueryModel* DiscountRepository::list(){auto*m=new QSqlQueryModel;m->setQuery("SELECT id_скидки,размер_скидки,условие FROM Скидка ORDER BY id_скидки",DatabaseManager::instance().database());return m;}
