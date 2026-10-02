#pragma once
#include "../common/ControllerBase.h"
#include <QSqlQueryModel>
class CarController:public ControllerBase{Q_OBJECT public:using ControllerBase::ControllerBase;QSqlQueryModel* load();};
