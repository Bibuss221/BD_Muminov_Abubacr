#pragma once
#include <QSqlDatabase>
#include "models/common/Config.h"
class DatabaseManager { public: static DatabaseManager& instance(); bool connect(const DbConfig&); bool isOpen() const; QSqlDatabase database() const; private: DatabaseManager()=default; };
