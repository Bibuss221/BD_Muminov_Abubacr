#include "ReportPage.h"

#include "models/reports/ReportRepository.h"

ReportPage::ReportPage(QWidget* parent)
    : TablePage(parent)
{
    table()->setModel(ReportRepository().carSummary());
}
