#pragma once

#include <QDate>

namespace DateRules
{
bool validRentalPeriod(
    const QDate& issueDate,
    const QDate& expectedReturnDate,
    const QDate& actualReturnDate = {});

bool overlaps(
    const QDate& firstStart,
    const QDate& firstEnd,
    const QDate& secondStart,
    const QDate& secondEnd);
}
