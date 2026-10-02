#include "PenaltyRepository.h"
#include "../database/DatabaseManager.h"
QSqlQueryModel* PenaltyRepository::list(){auto*m=new QSqlQueryModel;m->setQuery("SELECT id_штрафа,id_сделки,вид_нарушения,сумма_штрафа FROM Штраф ORDER BY id_штрафа DESC",DatabaseManager::instance().database());return m;}
