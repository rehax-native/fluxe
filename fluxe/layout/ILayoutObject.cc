#include "ILayoutObject.h"

using namespace fluxe;

void ILayoutObject::setPadding(Padding padding)
{
  this->padding = padding;
}

Padding ILayoutObject::getPadding()
{
  return padding;
}
