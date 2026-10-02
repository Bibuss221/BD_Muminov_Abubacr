#include <QApplication>
#include <QFile>

#include "views/auth/LoginWindow.h"

int main(int argc, char* argv[])
{
    QApplication app(argc, argv);

    app.setApplicationName(QStringLiteral("RentalCarSystem"));
    app.setOrganizationName(QStringLiteral("Muminov"));

    QFile styleFile(QStringLiteral(":/resources/style.qss"));

    if (styleFile.open(QIODevice::ReadOnly | QIODevice::Text)) {
        app.setStyleSheet(QString::fromUtf8(styleFile.readAll()));
    }

    LoginWindow window;
    window.show();

    return app.exec();
}
