#include "FlexLayout.h"
#include "LayoutConstraintSetter.h"
#include <algorithm>

using namespace fluxe;

LayoutSize FlexLayout::layout(LayoutConstraint constraints, PossibleLayoutSize parentSize, ILayoutObject * parent, std::vector<ILayoutObject*> items)
{
  getAvailableSize(constraints, parentSize, parent);

  collectAndMeasureChildren(items, constraints);
  setSizeOfFlexChildren(constraints);
  positionChildren();

  auto ownSizeMain = totalFlex > 0.0 || justifyContent != FlexJustifyContent::FlexStart ? availableMainAxis : childrenMainSizeFixed;
  auto ownSizeCross = alignItems != FlexAlignItems::FlexStart ? availableCrossAxis : childrenMaxCross;

  if (direction == FlexDirection::Row || direction == FlexDirection::RowReverse) {
    return {
      .width = ownSizeMain.value,
      .height = ownSizeCross.value,
    };
  } else {
    return {
      .width = ownSizeCross.value,
      .height = ownSizeMain.value,
    };
  }
}

void FlexLayout::getAvailableSize(LayoutConstraint constraints, PossibleLayoutSize parentSize, ILayoutObject * parent) {
  availableSize.width.unset();
  availableSize.height.unset();
    
  SizeDimensionTypes::Fixed * fp;

  if (parentSize.width.isSet) {
    availableSize.width.set(parentSize.width.value);
  } else if (parent->layoutSizeOverride.isSet && (fp = std::get_if<SizeDimensionTypes::Fixed>(&parent->layoutSizeOverride.value.width))) {
    availableSize.width.set(fp->size);
  } else if (constraints.maxWidth.isSet) {
    availableSize.width.set(constraints.maxWidth.value);
  }

  if (parentSize.height.isSet) {
    availableSize.height.set(parentSize.height.value);
  } else if (parent->layoutSizeOverride.isSet && (fp = std::get_if<SizeDimensionTypes::Fixed>(&parent->layoutSizeOverride.value.height))) {
    availableSize.height.set(fp->size);
  } else if (constraints.maxHeight.isSet) {
    availableSize.height.set(constraints.maxHeight.value);
  }

  if (direction == FlexDirection::Row || direction == FlexDirection::RowReverse) {
    availableMainAxis = availableSize.width;
    availableCrossAxis = availableSize.height;
  } else {
    availableMainAxis = availableSize.height;
    availableCrossAxis = availableSize.width;
  }
}

void FlexLayout::collectAndMeasureChildren(std::vector<ILayoutObject*> items, LayoutConstraint constraints) {
  children = {};
  totalFlex = 0.0;
  childrenMainSizeFixed = 0.0;
  childrenMaxCross = 0.0;

  LayoutConstraint nextConstraints {
    .maxWidth = constraints.maxWidth,
    .maxHeight = constraints.maxHeight,
    .minWidth = constraints.minWidth,
    .minHeight = constraints.minHeight,
  };

  for (int i = 0; i < items.size(); i++) {
    auto it = items.begin();
    std::advance(it, i);
    auto item = *it;
      
    auto info = i < itemInfos.size() ? itemInfos[i] : FlexItem {
      .order = 0,
    };
    if (!info.order.isSet) {
      info.order = 0;
    }

    if (!info.flexGrow.isSet) {
      item->measureLayout(constraints, availableSize);
      auto overrideResult = LayoutConstraintSetter::handleLayoutOverride(nextConstraints, availableSize, item);
      LayoutConstraintSetter::applyLayoutConstraints(item, constraints);

      float childSizeMain = direction == FlexDirection::Row || direction == FlexDirection::RowReverse ? item->layoutSize.value.width : item->layoutSize.value.height;
      float childSizeCross = direction == FlexDirection::Row || direction == FlexDirection::RowReverse ? item->layoutSize.value.height : item->layoutSize.value.width;

      childrenMainSizeFixed += childSizeMain;
      childrenMaxCross = std::max(childrenMaxCross, childSizeCross);
    } else {
      totalFlex += info.flexGrow.value;
    }

    children.push_back({
      .item = item,
      .info = info,
    });
  }
}

void FlexLayout::setSizeOfFlexChildren(LayoutConstraint constraints) {
  float flexSum = totalFlex;
  if (flexSum == 0.0) {
    flexSum = 1.0;
  }

  float remainingSizeMain = availableMainAxis.value - childrenMainSizeFixed;

  for (auto item : children) {
    if (item.info.flexGrow.isSet) {
      float size = remainingSizeMain / flexSum * item.info.flexGrow.value;

      float maxWidth = direction == FlexDirection::Row || direction == FlexDirection::RowReverse ? size : constraints.maxWidth.value;
      float maxHeight = direction == FlexDirection::Column || direction == FlexDirection::ColumnReverse ? size : constraints.maxHeight.value;
      LayoutConstraint itemConstraints {
        .maxWidth = maxWidth,
        .maxHeight = maxHeight,
        .minWidth = constraints.minWidth,
        .minHeight = constraints.minHeight,
      };

      item.item->measureLayout(itemConstraints, availableSize);
      auto overrideResult = LayoutConstraintSetter::handleLayoutOverride(itemConstraints, availableSize, item.item);
      LayoutConstraintSetter::applyLayoutConstraints(item.item, itemConstraints);

      float childSizeMain = direction == FlexDirection::Row || direction == FlexDirection::RowReverse ? item.item->layoutSize.value.width : item.item->layoutSize.value.height;
      float childSizeCross = direction == FlexDirection::Row || direction == FlexDirection::RowReverse ? item.item->layoutSize.value.height : item.item->layoutSize.value.width;

      childrenMaxCross = std::max(childrenMaxCross, childSizeCross);

      setChildMainSize(item.item, size);
    }
  }
}

void FlexLayout::positionChildren() {
  float mainPos = 0.0;
  float spacing = 0.0;

  switch (justifyContent) {
    case FlexJustifyContent::FlexStart:
      mainPos = 0.0;
      break;
    case FlexJustifyContent::FlexEnd:
      mainPos = totalFlex > 0.0 ? 0.0 : availableMainAxis.value - childrenMainSizeFixed;
      break;
    case FlexJustifyContent::Center:
      mainPos = totalFlex > 0.0 ? 0.0 : (availableMainAxis.value - childrenMainSizeFixed) / 2.0;
      break;
    case FlexJustifyContent::SpaceBetween:
      mainPos = 0.0;
      spacing = totalFlex > 0.0 || children.size() <= 1 ? 0.0 : (availableMainAxis.value - childrenMainSizeFixed) / (children.size() - 1);
      break;
    case FlexJustifyContent::SpaceAround:
      spacing = totalFlex > 0.0 ? 0.0 : (availableMainAxis.value - childrenMainSizeFixed) / (children.size() + 1);
      mainPos = spacing;
      break;
    case FlexJustifyContent::SpaceEvenly:
      break;
      // Not sure what this is?
  }

  float crossPos = 0.0;

  for (auto item : children) {
    item.item->layoutPosition = LayoutPosition {
      .left = 0.0,
      .top = 0.0,
    };

    setChildMainPos(item.item, mainPos);

    auto childSizeMain = direction == FlexDirection::Row || direction == FlexDirection::RowReverse ? item.item->layoutSize.value.width : item.item->layoutSize.value.height;
    auto childSizeCross = direction == FlexDirection::Row || direction == FlexDirection::RowReverse ? item.item->layoutSize.value.height : item.item->layoutSize.value.width;

    mainPos += childSizeMain + spacing;

    if (alignItems == FlexAlignItems::Center) {
      setChildCrossPos(item.item, (availableCrossAxis.value - childSizeCross) / 2.0);
    } else if (alignItems == FlexAlignItems::Stretch) {
      setChildCrossSize(item.item, availableCrossAxis.value);
      setChildCrossPos(item.item, 0);
    } else if (alignItems == FlexAlignItems::FlexEnd) {
      setChildCrossPos(item.item, availableCrossAxis.value - childSizeCross);
    }
  }
}


void FlexLayout::setChildMainSize(ILayoutObject * child, float size) {
  if (direction == FlexDirection::Row || direction == FlexDirection::RowReverse) {
    child->layoutSize.value.width = size;
  } else {
    child->layoutSize.value.height = size;
  }
}

void FlexLayout::setChildCrossSize(ILayoutObject * child, float size) {
  if (direction == FlexDirection::Row || direction == FlexDirection::RowReverse) {
    child->layoutSize.value.height = size;
  } else {
    child->layoutSize.value.width = size;
  }
}

void FlexLayout::setChildMainPos(ILayoutObject * child, float pos) {
  if (direction == FlexDirection::Row || direction == FlexDirection::RowReverse) {
    child->layoutPosition.value.left = pos;
  } else {
    child->layoutPosition.value.top = pos;
  }
}

void FlexLayout::setChildCrossPos(ILayoutObject * child, float pos) {
  if (direction == FlexDirection::Row || direction == FlexDirection::RowReverse) {
    child->layoutPosition.value.top = pos;
  } else {
    child->layoutPosition.value.left = pos;
  }
}
