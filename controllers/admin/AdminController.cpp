#include "AdminController.h"

QString AdminController::roleDescription() const
{
    return QStringLiteral(
        "Администратор БД отвечает за роли, права доступа, резервное копирование "
        "и обслуживание схемы PostgreSQL.");
}
