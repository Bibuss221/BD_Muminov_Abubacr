#pragma once

#include <QMessageBox>

class ConfirmDialog
{
public:
    static bool ask(QWidget* parent, const QString& text);
};
