#include "MainWindow.h"
#include "../clients/ClientPage.h"
#include "../cars/CarPage.h"
#include "../deals/DealPage.h"
#include <QTabWidget>
MainWindow::MainWindow(QWidget*p):QMainWindow(p){setWindowTitle("Информационная система проката автомобилей");auto*t=new QTabWidget(this);t->addTab(new ClientPage,"Клиенты");t->addTab(new CarPage,"Автомобили");t->addTab(new DealPage,"Сделки");setCentralWidget(t);}
