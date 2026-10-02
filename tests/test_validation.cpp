#include <QtTest>

#include "models/common/Validation.h"

class ValidationTest : public QObject
{
    Q_OBJECT

private slots:
    void required()
    {
        QVERIFY(Validation::required(QStringLiteral("Иван")));
        QVERIFY(!Validation::required(QStringLiteral("   ")));
    }
};

QTEST_APPLESS_MAIN(ValidationTest)

#include "test_validation.moc"
