#pragma once
#include <QWidget>
#include <QTableView>
class TablePage:public QWidget{Q_OBJECT public:explicit TablePage(QWidget*p=nullptr);QTableView* table()const{return table_;}private:QTableView*table_;};
