#include <QtTest>

#include "models/common/DateRules.h"

class DateRulesTest : public QObject
{
    Q_OBJECT

private slots:
    void validRentalPeriod()
    {
        QVERIFY(
            DateRules::validRentalPeriod(
                QDate(2026, 10, 1),
                QDate(2026, 10, 5)));

        QVERIFY(
            !DateRules::validRentalPeriod(
                QDate(2026, 10, 5),
                QDate(2026, 10, 1)));
    }
};

QTEST_APPLESS_MAIN(DateRulesTest)

#include "test_date_rules.moc"
