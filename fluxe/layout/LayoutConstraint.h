#pragma once

#include "../misc/Nullable.h"

namespace fluxe {

struct LayoutConstraint
{
  Nullable<float> minWidth;
  Nullable<float> minHeight;
  Nullable<float> maxWidth;
  Nullable<float> maxHeight;
};

struct LayoutOverrideResult
{
  bool hasSizeHorizontally = false;
  bool hasSizeVertically = false;
  bool hasPositionHorizontally = false;
  bool hasPositionVertically = false;
};

}
