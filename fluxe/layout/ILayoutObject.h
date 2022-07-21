#pragma once

#include "./LayoutTypes.h"
#include "../misc/Nullable.h"
#include "LayoutConstraint.h"

namespace fluxe {

class ILayoutObject
{
public:

  Nullable<LayoutSize> layoutSize;
  Nullable<LayoutPosition> layoutPosition;

  Nullable<LayoutSizeOverride> layoutSizeOverride;
  Nullable<LayoutPositionOverride> layoutPositionOverride;

  virtual void measureLayout(LayoutConstraint constraints, PossibleLayoutSize parentSize) = 0;
};

}
