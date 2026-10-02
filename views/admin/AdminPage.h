#pragma once

#include <QWidget>

class QLabel;

class AdminPage : public QWidget
{
    Q_OBJECT

public:
    explicit AdminPage(QWidget* parent = nullptr);

private:
    QLabel* description_;
};
