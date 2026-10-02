#include "LoginWindow.h"
#include "../dashboard/MainWindow.h"
#include "models/database/DatabaseManager.h"
#include <QFormLayout>
#include <QLineEdit>
#include <QPushButton>
#include <QMessageBox>
LoginWindow::LoginWindow(QWidget*p):QWidget(p){setWindowTitle("Прокат автомобилей — подключение");auto*f=new QFormLayout(this);host_=new QLineEdit("localhost");db_=new QLineEdit("rental_cars_db");user_=new QLineEdit("postgres");password_=new QLineEdit;password_->setEchoMode(QLineEdit::Password);auto*b=new QPushButton("Подключиться");f->addRow("Host",host_);f->addRow("Database",db_);f->addRow("User",user_);f->addRow("Password",password_);f->addRow(b);connect(b,&QPushButton::clicked,this,&LoginWindow::connectDb);}
void LoginWindow::connectDb(){DbConfig c;c.host=host_->text();c.database=db_->text();c.user=user_->text();c.password=password_->text();if(!DatabaseManager::instance().connect(c)){QMessageBox::critical(this,"Ошибка","Не удалось подключиться к PostgreSQL");return;}auto*w=new MainWindow;w->resize(1000,650);w->show();close();}
