#pragma once

#include "ILayout.h"

namespace fluxe {

enum class StackLayoutDirection {
  Vertical,
  Horizontal,
};

class StackLayout : public ILayout
{
public:
  float spacing = 0.0;
  StackLayoutDirection layoutDirection = StackLayoutDirection::Vertical;

  LayoutSize layout(LayoutConstraint constraints, PossibleLayoutSize parentSize, ILayoutObject * parent, std::vector<ILayoutObject*> items);

private:
  void reduceConstraintsWidth(LayoutConstraint & constraints, Nullable<float> amount);
  void reduceConstraintsHeight(LayoutConstraint & constraints, Nullable<float> amount);

};

}
