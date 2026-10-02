#pragma once

#include <QWidget>

class QLineEdit;

class LoginWindow : public QWidget
{
    Q_OBJECT

public:
    explicit LoginWindow(QWidget* parent = nullptr);

private slots:
    void connectDb();

private:
    QLineEdit* host_;
    QLineEdit* db_;
    QLineEdit* user_;
    QLineEdit* password_;
};
