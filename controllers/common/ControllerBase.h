#pragma once
#include <QObject>
class ControllerBase:public QObject{Q_OBJECT public:using QObject::QObject;signals:void error(const QString&);};
