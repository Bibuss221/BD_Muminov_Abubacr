#include "CarPage.h"
#include "controllers/cars/CarController.h"
CarPage::CarPage(QWidget*p):TablePage(p){table()->setModel(CarController(this).load());}
