#include "TablePage.h"

#include <QHeaderView>
#include <QVBoxLayout>

TablePage::TablePage(QWidget* parent)
    : QWidget(parent)
    , table_(new QTableView(this))
{
    auto* layout = new QVBoxLayout(this);

    table_->setAlternatingRowColors(true);
    table_->setSelectionBehavior(QAbstractItemView::SelectRows);
    table_->setEditTriggers(QAbstractItemView::NoEditTriggers);
    table_->horizontalHeader()->setStretchLastSection(true);

    layout->addWidget(table_);
}

QTableView* TablePage::table() const
{
    return table_;
}
