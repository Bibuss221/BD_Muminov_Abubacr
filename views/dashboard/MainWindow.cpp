#include "MainWindow.h"

#include "../cars/CarPage.h"
#include "../clients/ClientPage.h"
#include "../deals/DealPage.h"
#include "../discounts/DiscountPage.h"
#include "../penalties/PenaltyPage.h"
#include "../reports/ReportPage.h"

#include "models/database/DatabaseManager.h"

#include <QAction>
#include <QMessageBox>
#include <QStatusBar>
#include <QTabWidget>
#include <QToolBar>

MainWindow::MainWindow(QWidget* parent)
    : QMainWindow(parent)
{
    setWindowTitle(
        QStringLiteral("Информационная система проката автомобилей"));

    resize(1100, 700);

    auto* toolbar = addToolBar(QStringLiteral("Система"));
    toolbar->setMovable(false);

    QAction* checkDbAction =
        toolbar->addAction(QStringLiteral("Проверить БД"));

    connect(checkDbAction,
            &QAction::triggered,
            this,
            &MainWindow::checkDatabaseConnection);

    auto* tabs = new QTabWidget(this);

    tabs->addTab(new ClientPage(tabs),
                 QStringLiteral("Клиенты"));
    tabs->addTab(new CarPage(tabs),
                 QStringLiteral("Автомобили"));
    tabs->addTab(new DealPage(tabs),
                 QStringLiteral("Сделки"));
    tabs->addTab(new DiscountPage(tabs),
                 QStringLiteral("Скидки"));
    tabs->addTab(new PenaltyPage(tabs),
                 QStringLiteral("Штрафы"));
    tabs->addTab(new ReportPage(tabs),
                 QStringLiteral("Отчёт"));

    setCentralWidget(tabs);

    statusBar()->showMessage(
        DatabaseManager::instance().connectionSummary());
}

void MainWindow::checkDatabaseConnection()
{
    QString response;

    if (DatabaseManager::instance().ping(&response)) {
        statusBar()->showMessage(response, 10000);

        QMessageBox::information(
            this,
            QStringLiteral("Проверка PostgreSQL"),
            DatabaseManager::instance().connectionSummary()
                + QStringLiteral("

")
                + response);

        return;
    }

    statusBar()->showMessage(
        QStringLiteral("Ошибка проверки БД"),
        10000);

    QMessageBox::critical(
        this,
        QStringLiteral("Проверка PostgreSQL"),
        response);
}
