#pragma once

#include "ILayout.h"
#include <vector>

namespace fluxe {

enum class FlexDirection {
  Row,
  RowReverse,
  Column,
  ColumnReverse,
};

enum class FlexJustifyContent {
  /** items are packed toward the start line
      |AABBCCC    |
  **/
  FlexStart,

  /** items are packed toward to end line
      |    AABBCCC|
  **/
  FlexEnd,

  /** items are centered along the line
      |  AABBCCC  |
  **/
  Center,

  /** items are evenly distributed in the line; first item is on the start line, last item on the end line  
      |AA  BB  CCC|
  **/
  SpaceBetween,

  /** items are evenly distributed in the line with equal space around them
      | AA BB CCC |
  **/
  SpaceAround,

  /** items are distributed so that the spacing between any two adjacent alignment subjects, before the first alignment subject, and after the last alignment subject is the same
  **/
  SpaceEvenly,
};

enum class FlexAlignItems {
  FlexStart, // cross-start margin edge of the items is placed on the cross-start line
  FlexEnd, // cross-end margin edge of the items is placed on the cross-end line
  Center, // items are centered in the cross-axis
  // var Baseline; // items are aligned such as their baselines align
  Stretch, // stretch to fill the container (still respect min-width/max-width)
};

struct FlexItem {
  Nullable<int> order;
  Nullable<float> flexGrow;
  Nullable<FlexAlignItems> alignSelf;
};

class FlexLayout : public ILayout
{
public:

  LayoutSize layout(LayoutConstraint constraints, PossibleLayoutSize parentSize, ILayoutObject * parent, std::vector<ILayoutObject*> items);

  FlexDirection direction = FlexDirection::Row;
  FlexJustifyContent justifyContent = FlexJustifyContent::FlexStart;
  FlexAlignItems alignItems = FlexAlignItems::FlexStart;
  std::vector<FlexItem> itemInfos;

private:

  void positionChildren();
  void setSizeOfFlexChildren(LayoutConstraint constraints);
  void collectAndMeasureChildren(std::vector<ILayoutObject*> items, LayoutConstraint constraints);
  void getAvailableSize(LayoutConstraint constraints, PossibleLayoutSize parentSize, ILayoutObject * parent);
  void setChildMainSize(ILayoutObject * child, float size);
  void setChildCrossSize(ILayoutObject * child, float size);
  void setChildMainPos(ILayoutObject * child, float pos);
  void setChildCrossPos(ILayoutObject * child, float pos);


  PossibleLayoutSize availableSize;

  Nullable<float> availableMainAxis;
  Nullable<float> availableCrossAxis;

  struct ChildInfo {
    ILayoutObject * item;
    FlexItem info;
  };

  std::vector<ChildInfo> children;
  float totalFlex = 0.0;
  float childrenMainSizeFixed = 0.0;
  float childrenMaxCross = 0.0;


};

}
