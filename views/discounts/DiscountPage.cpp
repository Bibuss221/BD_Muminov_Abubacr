#include "DiscountPage.h"

#include "models/discounts/DiscountRepository.h"

DiscountPage::DiscountPage(QWidget* parent)
    : TablePage(parent)
{
    table()->setModel(DiscountRepository().list());
}
