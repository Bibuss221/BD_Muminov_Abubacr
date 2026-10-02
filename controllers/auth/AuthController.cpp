#include "AuthController.h"

AuthController::AuthController(QObject* parent)
    : QObject(parent)
{
}

void AuthController::setCurrentRole(const QString& role)
{
    role_ = role;
}

QString AuthController::currentRole() const
{
    return role_;
}
