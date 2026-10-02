#pragma once

#include <QObject>
#include <QStringList>

class DashboardController : public QObject
{
    Q_OBJECT

public:
    using QObject::QObject;

    QStringList sections() const;
};
