#pragma once

#include <QObject>
#include <QString>

class AuthController : public QObject
{
    Q_OBJECT

public:
    explicit AuthController(QObject* parent = nullptr);

    void setCurrentRole(const QString& role);
    QString currentRole() const;

private:
    QString role_;
};
