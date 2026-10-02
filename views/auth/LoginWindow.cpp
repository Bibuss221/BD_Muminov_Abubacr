#include "LoginWindow.h"

#include "../dashboard/MainWindow.h"
#include "models/database/DatabaseManager.h"

#include <QFormLayout>
#include <QLineEdit>
#include <QMessageBox>
#include <QPushButton>

LoginWindow::LoginWindow(QWidget* parent)
    : QWidget(parent)
{
    setWindowTitle(QStringLiteral("Прокат автомобилей — подключение"));

    auto* form = new QFormLayout(this);

    host_ = new QLineEdit(QStringLiteral("localhost"), this);
    db_ = new QLineEdit(QStringLiteral("rental_cars_db"), this);
    user_ = new QLineEdit(QStringLiteral("postgres"), this);

    password_ = new QLineEdit(this);
    password_->setEchoMode(QLineEdit::Password);

    auto* connectButton =
        new QPushButton(QStringLiteral("Подключиться"), this);

    form->addRow(QStringLiteral("Host:"), host_);
    form->addRow(QStringLiteral("Database:"), db_);
    form->addRow(QStringLiteral("User:"), user_);
    form->addRow(QStringLiteral("Password:"), password_);
    form->addRow(connectButton);

    connect(connectButton,
            &QPushButton::clicked,
            this,
            &LoginWindow::connectDb);
}

void LoginWindow::connectDb()
{
    DbConfig config;
    config.host = host_->text().trimmed();
    config.database = db_->text().trimmed();
    config.user = user_->text().trimmed();
    config.password = password_->text();

    if (!DatabaseManager::instance().connect(config)) {
        QMessageBox::critical(
            this,
            QStringLiteral("Ошибка подключения"),
            QStringLiteral(
                "Не удалось открыть соединение с PostgreSQL.\n"
                "Проверь Host, порт, имя БД, пользователя, пароль и драйвер QPSQL."));

        return;
    }

    auto* mainWindow = new MainWindow;
    mainWindow->show();

    close();
}
