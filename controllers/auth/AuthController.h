#pragma once
#include <QObject>
class AuthController:public QObject{Q_OBJECT public:using QObject::QObject;QString currentRole()const{return role_;}private:QString role_;};
