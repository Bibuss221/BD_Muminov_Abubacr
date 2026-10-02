#include "ReportRepository.h"
#include "../database/DatabaseManager.h"
QSqlQueryModel* ReportRepository::carSummary(){auto*m=new QSqlQueryModel;m->setQuery("SELECT * FROM v_car_rent_summary ORDER BY количество_сделок DESC",DatabaseManager::instance().database());return m;}
