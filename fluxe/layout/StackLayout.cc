#include "StackLayout.h"
#include "LayoutConstraintSetter.h"
#include <algorithm>

using namespace fluxe;

LayoutSize StackLayout::layout(LayoutConstraint constraints, PossibleLayoutSize parentSize, ILayoutObject * parent, std::vector<ILayoutObject*> items)
{
  float pos = spacing;
  float maxCross = 0;
  LayoutConstraint nextConstraints = {
    .maxWidth = constraints.maxWidth,
    .maxHeight = constraints.maxHeight,
    .minWidth = constraints.minWidth,
    .minHeight = constraints.minHeight,
  };
  for (auto & item : items)
  {
    item->measureLayout(constraints, parentSize);
    auto overrideResult = LayoutConstraintSetter::handleLayoutOverride(nextConstraints, parentSize, item);
    LayoutConstraintSetter::applyLayoutConstraints(item, constraints);

    if (layoutDirection == StackLayoutDirection::Vertical) {
      if (overrideResult.hasSizeVertically) {
        item->layoutPosition = LayoutPosition {
          .left = spacing,
          .top = pos,
        };
        pos += item->layoutSize.value.height + spacing;
        reduceConstraintsHeight(nextConstraints, item->layoutSize.value.height);
      }
      maxCross = std::max(maxCross, item->layoutSize.value.width + spacing * 2.0f);
    } else {
      if (overrideResult.hasSizeHorizontally) {
        item->layoutPosition = LayoutPosition {
          .left = pos,
          .top = spacing,
        };
        pos += item->layoutSize.value.width + spacing;
        reduceConstraintsWidth(nextConstraints, item->layoutSize.value.width);
      }
      maxCross = std::max(maxCross, item->layoutSize.value.width + spacing * 2.0f);
    }
  }

  if (layoutDirection == StackLayoutDirection::Vertical) {
    return { .width = maxCross, .height = pos };
  } else {
    return { .width = pos, .height = maxCross };
  }
}

void StackLayout::reduceConstraintsWidth(LayoutConstraint constraints, Nullable<float> amount)
{
  if (constraints.maxWidth.isSet && amount.isSet) {
    constraints.maxWidth.value -= amount.value;
  }
}

void StackLayout::reduceConstraintsHeight(LayoutConstraint constraints, Nullable<float> amount)
{
  if (constraints.maxHeight.isSet && amount.isSet) {
    constraints.maxHeight.value -= amount.value;
  }
}
