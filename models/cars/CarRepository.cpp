#include "CarRepository.h"
#include "../database/DatabaseManager.h"
QSqlQueryModel* CarRepository::list(){auto*m=new QSqlQueryModel;m->setQuery("SELECT гос_номер,марка,тип,стоимость,год_выпуска FROM Автомобиль ORDER BY марка",DatabaseManager::instance().database());return m;}
