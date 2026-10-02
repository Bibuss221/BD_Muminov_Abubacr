#include "DashboardController.h"

QStringList DashboardController::sections() const
{
    return {
        QStringLiteral("Клиенты"),
        QStringLiteral("Автомобили"),
        QStringLiteral("Сделки"),
        QStringLiteral("Отчёт")
    };
}
