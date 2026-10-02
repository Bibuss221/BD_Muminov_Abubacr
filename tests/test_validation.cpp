#include <QtTest>
#include "models/common/Validation.h"
class T:public QObject{Q_OBJECT private slots:void required(){QVERIFY(Validation::required("Иван"));QVERIFY(!Validation::required("   "));}};QTEST_APPLESS_MAIN(T)
#include "test_validation.moc"
