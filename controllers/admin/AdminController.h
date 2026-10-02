#pragma once

#include <QObject>
#include <QString>

class AdminController : public QObject
{
    Q_OBJECT

public:
    using QObject::QObject;

    QString roleDescription() const;
};
