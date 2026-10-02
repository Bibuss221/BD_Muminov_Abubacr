#include "DateRules.h"
namespace DateRules { bool validRentalPeriod(const QDate& i,const QDate& e,const QDate& a){return i.isValid()&&e>=i&&(!a.isValid()||a>=i);} bool overlaps(const QDate& as,const QDate& ae,const QDate& bs,const QDate& be){return as<=be&&bs<=ae;} }
