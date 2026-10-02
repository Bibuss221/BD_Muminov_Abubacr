#pragma once

#include <QTableView>
#include <QWidget>

class TablePage : public QWidget
{
    Q_OBJECT

public:
    explicit TablePage(QWidget* parent = nullptr);

    QTableView* table() const;

private:
    QTableView* table_;
};
