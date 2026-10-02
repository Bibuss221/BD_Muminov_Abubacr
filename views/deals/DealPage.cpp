#include "DealPage.h"

#include "controllers/deals/DealController.h"

DealPage::DealPage(QWidget* parent)
    : TablePage(parent)
{
    auto* controller = new DealController(this);
    table()->setModel(controller->load());
}
