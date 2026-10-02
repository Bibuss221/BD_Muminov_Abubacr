#include "DealPage.h"
#include "controllers/deals/DealController.h"
DealPage::DealPage(QWidget*p):TablePage(p){table()->setModel(DealController(this).load());}
