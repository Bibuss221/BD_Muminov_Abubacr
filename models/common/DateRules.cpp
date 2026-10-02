#include "DateRules.h"

namespace DateRules
{
bool validRentalPeriod(
    const QDate& issueDate,
    const QDate& expectedReturnDate,
    const QDate& actualReturnDate)
{
    if (!issueDate.isValid()) {
        return false;
    }

    if (expectedReturnDate < issueDate) {
        return false;
    }

    return !actualReturnDate.isValid() || actualReturnDate >= issueDate;
}

bool overlaps(
    const QDate& firstStart,
    const QDate& firstEnd,
    const QDate& secondStart,
    const QDate& secondEnd)
{
    return firstStart <= secondEnd && secondStart <= firstEnd;
}
}
