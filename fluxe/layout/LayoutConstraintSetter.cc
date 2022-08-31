#include "LayoutConstraintSetter.h"
#include <iostream>

using namespace fluxe;

void LayoutConstraintSetter::setSizeIfNeeded(ILayoutObject * item)
{
  if (!item->layoutSize.isSet) {
    item->layoutSize.set({
      .width = 0,
      .height = 0,
    });
  }
}

void LayoutConstraintSetter::applyLayoutConstraints(ILayoutObject * item, Nullable<LayoutConstraint> constraints)
{
  if (constraints.isSet) {
    setSizeIfNeeded(item);
    if (constraints.value.minWidth.isSet && item->layoutSize.value.width < constraints.value.minWidth.value) {
      item->layoutSize.value.width = constraints.value.minWidth.value;
    }
    if (constraints.value.maxWidth.isSet && item->layoutSize.value.width > constraints.value.maxWidth.value) {
      item->layoutSize.value.width = constraints.value.maxWidth.value;
    }
    if (constraints.value.minHeight.isSet && item->layoutSize.value.height < constraints.value.minHeight.value) {
      item->layoutSize.value.height = constraints.value.minHeight.value;
    }
    if (constraints.value.maxHeight.isSet && item->layoutSize.value.height > constraints.value.maxHeight.value) {
      item->layoutSize.value.height = constraints.value.maxHeight.value;
    }
  }
}

LayoutOverrideResult LayoutConstraintSetter::handleLayoutOverride(Nullable<LayoutConstraint> constraints, PossibleLayoutSize parentSize, ILayoutObject * item)
{
  auto hasSizeVertically = true;
  auto hasSizeHorizontally = true;
  auto hasPositionHorizontally = false;
  auto hasPositionVertically = false;

  if (item->layoutSizeOverride.isSet) {
    if (auto * p = std::get_if<SizeDimensionTypes::Fixed>(&item->layoutSizeOverride.value.width)) {
      item->layoutSize.value.width = p->size;
    } else if (auto * p = std::get_if<SizeDimensionTypes::Fill>(&item->layoutSizeOverride.value.width)) {
      if (parentSize.width.isSet) {
        item->layoutSize.value.width = parentSize.width.value;
      } else if (constraints.isSet) {
        if (constraints.value.maxWidth.isSet) {
          item->layoutSize.value.width = constraints.value.maxWidth.value;
        } else {
          hasSizeHorizontally = false;
        }
      } else {
        hasSizeHorizontally = false;
      }
    } else if (auto * p = std::get_if<SizeDimensionTypes::Percentage>(&item->layoutSizeOverride.value.width)) {
      float percent = p->percent;
      if (parentSize.width.isSet) {
        item->layoutSize.value.width = parentSize.width.value * percent / 100.0;
      } else if (constraints.isSet) {
        if (constraints.value.maxWidth.isSet) {
          item->layoutSize.value.width = constraints.value.maxWidth.value * percent / 100.0;
        } else {
          hasSizeHorizontally = false;
        }
      } else {
        hasSizeHorizontally = false;
      }
    }

    if (auto * p = std::get_if<SizeDimensionTypes::Fixed>(&item->layoutSizeOverride.value.height)) {
      item->layoutSize.value.height = p->size;
    } else if (auto * p = std::get_if<SizeDimensionTypes::Fill>(&item->layoutSizeOverride.value.height)) {
      if (parentSize.height.isSet) {
        item->layoutSize.value.height = parentSize.height.value;
      } else if (constraints.isSet) {
        if (constraints.value.maxHeight.isSet) {
          item->layoutSize.value.height = constraints.value.maxHeight.value;
        } else {
          hasSizeVertically = false;
        }
      } else {
        hasSizeVertically = false;
      }
    } else if (auto * p = std::get_if<SizeDimensionTypes::Percentage>(&item->layoutSizeOverride.value.height)) {
      float percent = p->percent;
      if (parentSize.height.isSet) {
        item->layoutSize.value.height = parentSize.height.value * percent / 100.0;
      } else if (constraints.isSet) {
        if (constraints.value.maxHeight.isSet) {
          item->layoutSize.value.height = constraints.value.maxHeight.value * percent / 100.0;
        } else {
          hasSizeVertically = false;
        }
      } else {
        hasSizeVertically = false;
      }
    }
  }

  if (item->layoutPositionOverride.isSet) {
    if (auto * p = std::get_if<PositionDimensionTypes::Fixed>(&item->layoutPositionOverride.value.left)) {
      item->layoutPosition.value.left = p->amount;
      item->layoutPosition.isSet = true;
      hasPositionHorizontally = true;
    } else if (auto * p = std::get_if<PositionDimensionTypes::Percentage>(&item->layoutPositionOverride.value.left)) {
      float percent = p->percent;
      if (parentSize.width.isSet) {
        item->layoutPosition.value.left = parentSize.width.value * percent / 100.0;
        item->layoutPosition.isSet = true;
        hasPositionHorizontally = true;
      } else if (constraints.isSet) {
        if (constraints.value.maxWidth.isSet) {
          item->layoutPosition.value.left = constraints.value.maxWidth.value * percent / 100.0;
          item->layoutPosition.isSet = true;
          hasPositionHorizontally = true;
        }
      }
    }

    if (auto * p = std::get_if<PositionDimensionTypes::Fixed>(&item->layoutPositionOverride.value.top)) {
      item->layoutPosition.value.top = p->amount;
      item->layoutPosition.isSet = true;
      hasPositionVertically = true;
    } else if (auto * p = std::get_if<PositionDimensionTypes::Percentage>(&item->layoutPositionOverride.value.top)) {
      float percent = p->percent;
      if (parentSize.height.isSet) {
        item->layoutPosition.value.top = parentSize.height.value * percent / 100.0;
        item->layoutPosition.isSet = true;
        hasPositionVertically = true;
      } else if (constraints.isSet) {
        if (constraints.value.maxHeight.isSet) {
          item->layoutPosition.value.top = constraints.value.maxHeight.value * percent / 100.0;
          item->layoutPosition.isSet = true;
          hasPositionVertically = true;
        }
      }
    }

    if (auto * p = std::get_if<PositionDimensionTypes::Fixed>(&item->layoutPositionOverride.value.right)) {
      item->layoutPosition.value.left = p->amount - item->layoutSize.value.width;
      item->layoutPosition.isSet = true;
      hasPositionHorizontally = true;
    } else if (auto * p = std::get_if<PositionDimensionTypes::Percentage>(&item->layoutPositionOverride.value.right)) {
      float percent = p->percent;
      if (parentSize.width.isSet) {
        item->layoutPosition.value.left = parentSize.width.value * percent / 100.0 - item->layoutSize.value.width;
        item->layoutPosition.isSet = true;
        hasPositionHorizontally = true;
      } else if (constraints.isSet) {
        if (constraints.value.maxWidth.isSet) {
          item->layoutPosition.value.left = constraints.value.maxWidth.value * percent / 100.0 - item->layoutSize.value.width;
          item->layoutPosition.isSet = true;
          hasPositionHorizontally = true;
        }
      }
    }

    if (auto * p = std::get_if<PositionDimensionTypes::Fixed>(&item->layoutPositionOverride.value.bottom)) {
      item->layoutPosition.value.top = p->amount - item->layoutSize.value.height;
      item->layoutPosition.isSet = true;
      hasPositionVertically = true;
    } else if (auto * p = std::get_if<PositionDimensionTypes::Percentage>(&item->layoutPositionOverride.value.bottom)) {
      float percent = p->percent;
      if (parentSize.height.isSet) {
        item->layoutPosition.value.top = parentSize.height.value * percent / 100.0 - item->layoutSize.value.height;
        item->layoutPosition.isSet = true;
        hasPositionVertically = true;
      } else if (constraints.isSet) {
        if (constraints.value.maxHeight.isSet) {
          item->layoutPosition.value.top = constraints.value.maxHeight.value * percent / 100.0 - item->layoutSize.value.height;
          item->layoutPosition.isSet = true;
          hasPositionVertically = true;
        }
      }
    }
  }

  return {
    .hasSizeHorizontally = hasSizeHorizontally,
    .hasSizeVertically = hasSizeVertically,
    .hasPositionHorizontally = hasPositionHorizontally,
    .hasPositionVertically = hasPositionVertically
  };
}
