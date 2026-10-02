#include "ClientPage.h"
#include "controllers/clients/ClientController.h"
ClientPage::ClientPage(QWidget*p):TablePage(p){table()->setModel(ClientController(this).load());}
