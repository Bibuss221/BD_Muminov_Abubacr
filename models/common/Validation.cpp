#include "Validation.h"

namespace Validation
{
bool required(const QString& value)
{
    return !value.trimmed().isEmpty();
}
}
