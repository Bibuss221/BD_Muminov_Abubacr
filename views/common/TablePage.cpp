#include "TablePage.h"
#include <QVBoxLayout>
TablePage::TablePage(QWidget*p):QWidget(p),table_(new QTableView(this)){auto*l=new QVBoxLayout(this);l->addWidget(table_);}
