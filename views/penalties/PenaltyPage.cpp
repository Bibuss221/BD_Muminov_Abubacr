#include "PenaltyPage.h"

#include "models/penalties/PenaltyRepository.h"

PenaltyPage::PenaltyPage(QWidget* parent)
    : TablePage(parent)
{
    table()->setModel(PenaltyRepository().list());
}
