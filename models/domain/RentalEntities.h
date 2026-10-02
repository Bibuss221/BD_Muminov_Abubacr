#pragma once

#include <QString>

struct Client
{
    int id = 0;
    QString lastName;
    QString firstName;
    QString middleName;
    QString address;
    QString phone;
};

struct Car
{
    QString plateNumber;
    QString brand;
    QString type;
    double dailyCost = 0.0;
    int year = 0;
};

struct Deal
{
    int id = 0;
    int clientId = 0;
    QString plateNumber;
    QString issueDate;
    QString expectedReturnDate;
    QString actualReturnDate;
    double rentalCost = 0.0;
};

struct Discount
{
    int id = 0;
    double percent = 0.0;
    QString condition;
};

struct Penalty
{
    int id = 0;
    int dealId = 0;
    QString violation;
    double amount = 0.0;
};
