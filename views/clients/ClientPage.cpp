#include "ClientPage.h"

#include "controllers/clients/ClientController.h"

ClientPage::ClientPage(QWidget* parent)
    : TablePage(parent)
{
    auto* controller = new ClientController(this);
    table()->setModel(controller->load());
}
