#include "CarPage.h"

#include "controllers/cars/CarController.h"

CarPage::CarPage(QWidget* parent)
    : TablePage(parent)
{
    auto* controller = new CarController(this);
    table()->setModel(controller->load());
}
