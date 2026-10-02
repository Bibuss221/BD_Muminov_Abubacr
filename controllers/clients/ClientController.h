#pragma once
#include "../common/ControllerBase.h"
#include <QSqlQueryModel>
class ClientController:public ControllerBase{Q_OBJECT public:using ControllerBase::ControllerBase;QSqlQueryModel* load();};
