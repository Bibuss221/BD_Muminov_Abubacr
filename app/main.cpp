#include <QApplication>
#include "views/auth/LoginWindow.h"
int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    app.setApplicationName("RentalCarSystem");
    LoginWindow window;
    window.show();
    return app.exec();
}
