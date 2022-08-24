#include "StackLayout.h"
#include "LayoutConstraintSetter.h"
#include <algorithm>

using namespace fluxe;

LayoutSize StackLayout::layout(LayoutConstraint constraints, PossibleLayoutSize parentSize, ILayoutObject * parent, std::vector<ILayoutObject*> items)
{
  auto overrideResult = LayoutConstraintSetter::handleLayoutOverride(constraints, parentSize, parent);

  float pos = spacing + (layoutDirection == StackLayoutDirection::Vertical ? parent->getPadding().top : parent->getPadding().left);
  float maxPos = pos;
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
        if (!overrideResult.hasPositionVertically) {
          item->layoutPosition = LayoutPosition {
            .left = spacing,
            .top = pos,
          };
          pos += item->layoutSize.value.height + spacing;
          reduceConstraintsHeight(nextConstraints, item->layoutSize.value.height);
        } else {
          if (item->layoutPosition.value.left + item->layoutSize.value.width + spacing > maxPos) {
            maxPos = item->layoutPosition.value.left + item->layoutSize.value.width + spacing;
          }
        }
      }
      maxCross = std::max(maxCross, item->layoutPosition.value.left + item->layoutSize.value.width + spacing);
    } else {
      if (overrideResult.hasSizeHorizontally) {
        if (!overrideResult.hasPositionHorizontally) {
          item->layoutPosition = LayoutPosition {
            .left = pos,
            .top = spacing,
          };
          pos += item->layoutSize.value.width + spacing;
          reduceConstraintsWidth(nextConstraints, item->layoutSize.value.width);
        } else {
          if (item->layoutPosition.value.top + item->layoutSize.value.height + spacing > maxPos) {
            maxPos = item->layoutPosition.value.top + item->layoutSize.value.height + spacing;
          }
        }
      }
      maxCross = std::max(maxCross, item->layoutPosition.value.top + item->layoutSize.value.width + spacing);
    }
  }

  if (pos > maxPos) {
    maxPos = pos;
  }

  if (layoutDirection == StackLayoutDirection::Vertical) {
    return { .width = maxCross + parent->getPadding().left + parent->getPadding().right, .height = maxPos + parent->getPadding().bottom };
  } else {
    return { .width = maxPos + parent->getPadding().right, .height = maxCross + parent->getPadding().top + parent->getPadding().bottom };
  }
}

void StackLayout::reduceConstraintsWidth(LayoutConstraint & constraints, Nullable<float> amount)
{
  if (constraints.maxWidth.isSet && amount.isSet) {
    constraints.maxWidth.value -= amount.value;
  }
}

void StackLayout::reduceConstraintsHeight(LayoutConstraint & constraints, Nullable<float> amount)
{
  if (constraints.maxHeight.isSet && amount.isSet) {
    constraints.maxHeight.value -= amount.value;
  }
}
