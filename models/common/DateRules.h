#pragma once
#include <QDate>
namespace DateRules { bool validRentalPeriod(const QDate&,const QDate&,const QDate& = {}); bool overlaps(const QDate&,const QDate&,const QDate&,const QDate&); }
