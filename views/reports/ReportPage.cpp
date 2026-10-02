#include "ReportPage.h"
#include "models/reports/ReportRepository.h"
ReportPage::ReportPage(QWidget*p):TablePage(p){table()->setModel(ReportRepository().carSummary());}
