#pragma once
#include <QSqlQuery>
class RepositoryBase { protected: QSqlQuery query() const; };
