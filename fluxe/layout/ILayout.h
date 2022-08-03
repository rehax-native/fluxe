#pragma once

#include <vector>
#include "./LayoutTypes.h"
#include <rehaxUtils/pointers/Object.h>
#include "LayoutConstraint.h"
#include "ILayoutObject.h"

using namespace rehaxUtils;

namespace fluxe {

class ILayout : public Object<ILayout>
{
public:
  virtual LayoutSize layout(LayoutConstraint constraints, PossibleLayoutSize parentSize, ILayoutObject * parent, std::vector<ILayoutObject *> items) = 0;
};

}
