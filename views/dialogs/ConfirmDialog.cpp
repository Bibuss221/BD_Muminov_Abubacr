#include "ConfirmDialog.h"

bool ConfirmDialog::ask(QWidget* parent, const QString& text)
{
    const auto result = QMessageBox::question(
        parent,
        QStringLiteral("Подтверждение"),
        text,
        QMessageBox::Yes | QMessageBox::No);

    return result == QMessageBox::Yes;
}
