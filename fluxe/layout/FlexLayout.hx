package fluxe.layout;

using fluxe.layout.LayoutTypes;
using fluxe.layout.LayoutConstraint;

enum FlexDirection {
  Row;
  RowReverse;
  Column;
  ColumnReverse;
}

enum FlexJustifyContent {
  /** items are packed toward the start line
      |AABBCCC    |
  **/
  FlexStart;

  /** items are packed toward to end line
      |    AABBCCC|
  **/
  FlexEnd;

  /** items are centered along the line
      |  AABBCCC  |
  **/
  Center;

  /** items are evenly distributed in the line; first item is on the start line, last item on the end line  
      |AA  BB  CCC|
  **/
  SpaceBetween;

  /** items are evenly distributed in the line with equal space around them
      | AA BB CCC |
  **/
  SpaceAround;

  /** items are distributed so that the spacing between any two adjacent alignment subjects, before the first alignment subject, and after the last alignment subject is the same
  **/
  SpaceEvenly;
}

enum FlexAlignItems {
  FlexStart; // cross-start margin edge of the items is placed on the cross-start line
  FlexEnd; // cross-end margin edge of the items is placed on the cross-end line
  Center; // items are centered in the cross-axis
  // var Baseline; // items are aligned such as their baselines align
  Stretch; // stretch to fill the container (still respect min-width/max-width)
}

typedef FlexItem = {
  ?order:Int,
  ?flexGrow:Float,
  ?alignSelf:FlexAlignItems,
}

class FlexLayout implements ILayout {
  public function new() {}

  public var itemInfos:Array<FlexItem> = [];

  public var direction(default, set):FlexDirection = Row;

  public function set_direction(direction:FlexDirection):FlexDirection {
    this.direction = direction;
    return direction;
  }

  public var justifyContent(default, default):FlexJustifyContent = FlexStart;
  public var alignItems(default, default):FlexAlignItems = FlexStart;

  private var availableSize:PossibleLayoutSize = {
    width: null,
    height: null,
  };
  private var availableMainAxis:Null<Float> = null;
  private var availableCrossAxis:Null<Float> = null;

  private var children:Array<{
    item: ILayoutObject,
    info: FlexItem,
  }> = [];
  private var totalFlex = 0.0;
  private var childrenMainSizeFixed = 0.0;
  private var childrenMaxCross = 0.0;

  public function layout(constraints:LayoutConstraint, parentSize:PossibleLayoutSize, parent: ILayoutObject, items:Array<ILayoutObject>):LayoutSize {
    getAvailableSize(constraints, parentSize, parent);
    // trace('Flex');
    // trace('Direction ${direction}');
    // trace('Available size main: ${availableMainAxis} cross ${availableCrossAxis}');

    collectAndMeasureChildren(items, constraints);
    setSizeOfFlexChildren(constraints);
    positionChildren();

    var ownSizeMain = totalFlex > 0.0 || justifyContent != FlexStart ? availableMainAxis : childrenMainSizeFixed;
    var ownSizeCross = alignItems != FlexStart ? availableCrossAxis : childrenMaxCross;

    // trace('Own size main: ${ownSizeMain} ${ownSizeCross}');
    // trace('\n\n');

    if (direction == Row || direction == RowReverse) {
      return {
        width: ownSizeMain,
        height: ownSizeCross,
      };
    } else {
      return {
        width: ownSizeCross,
        height: ownSizeMain,
      };
    }
  }

  private function getAvailableSize(constraints:LayoutConstraint, parentSize:PossibleLayoutSize, parent:ILayoutObject) {
    availableSize.width = null;
    availableSize.height = null;

    if (parentSize.width != null) {
      availableSize.width = parentSize.width;
    } else if (parent.layoutSizeOverride != null && parent.layoutSizeOverride.width.match(Fixed(_))) {
      switch (parent.layoutSizeOverride.width) {
        case Fixed(w):
          availableSize.width = w;
        default:
      }
    } else if (constraints.maxWidth != null) {
      availableSize.width = constraints.maxWidth;
    }

    if (parentSize.height != null) {
      availableSize.height = parentSize.height;
    } else if (parent.layoutSizeOverride != null && parent.layoutSizeOverride.height.match(Fixed(_))) {
      switch (parent.layoutSizeOverride.height) {
        case Fixed(w):
          availableSize.height = w;
        default:
      }
    } else if (constraints.maxHeight != null) {
      availableSize.height = constraints.maxHeight;
    }

    if (direction == Row || direction == RowReverse) {
      availableMainAxis = availableSize.width;
      availableCrossAxis = availableSize.height;
    } else {
      availableMainAxis = availableSize.height;
      availableCrossAxis = availableSize.width;
    }
  }

  private function collectAndMeasureChildren(items:Array<ILayoutObject>, constraints:LayoutConstraint) {
    children = [];
    totalFlex = 0.0;
    childrenMainSizeFixed = 0.0;
    childrenMaxCross = 0.0;

    var nextConstraints = {
      maxWidth: constraints.maxWidth,
      maxHeight: constraints.maxHeight,
      minWidth: constraints.minWidth,
      minHeight: constraints.minHeight,
    };

    for (i in 0...items.length) {
      var item = items[i];
      var info = i < itemInfos.length ? itemInfos[i] : {
        order: 0,
      };
      if (info.order == null) {
        info.order = 0;
      }

      if (info.flexGrow == null) {
        item.measureLayout(constraints, availableSize);
        var overrideResult = LayoutConstraintSetter.handleLayoutOverride(nextConstraints, availableSize, item);
        LayoutConstraintSetter.applyLayoutConstraints(item, constraints);

        var childSizeMain = direction == Row || direction == RowReverse ? item.layoutSize.width : item.layoutSize.height;
        var childSizeCross = direction == Row || direction == RowReverse ? item.layoutSize.height : item.layoutSize.width;

        childrenMainSizeFixed += childSizeMain;
        childrenMaxCross = Math.max(childrenMaxCross, childSizeCross);
      } else {
        totalFlex += info.flexGrow;
      }

      children.push({
        item: item,
        info: info
      });
    }
  }

  private function setSizeOfFlexChildren(constraints:LayoutConstraint) {
    var flexSum = totalFlex;
    if (flexSum == 0.0) {
      flexSum = 1.0;
    }

    var remainingSizeMain = availableMainAxis - childrenMainSizeFixed;

    for (item in children) {
      if (item.info.flexGrow != null) {
        var size = remainingSizeMain / flexSum * item.info.flexGrow;

        var maxWidth = direction == Row || direction == RowReverse ? size : constraints.maxWidth;
        var maxHeight = direction == Column || direction == ColumnReverse ? size : constraints.maxHeight;
        var itemConstraints = {
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          minWidth: constraints.minWidth,
          minHeight: constraints.minHeight,
        };

        item.item.measureLayout(itemConstraints, availableSize);
        var overrideResult = LayoutConstraintSetter.handleLayoutOverride(itemConstraints, availableSize, item.item);
        LayoutConstraintSetter.applyLayoutConstraints(item.item, itemConstraints);

        var childSizeMain = direction == Row || direction == RowReverse ? item.item.layoutSize.width : item.item.layoutSize.height;
        var childSizeCross = direction == Row || direction == RowReverse ? item.item.layoutSize.height : item.item.layoutSize.width;

        childrenMaxCross = Math.max(childrenMaxCross, childSizeCross);

        setChildMainSize(item.item, size);
      }
    }
  }

  private function positionChildren() {
    var mainPos = 0.0;
    var spacing = 0.0;
    switch (justifyContent) {
      case FlexStart:
        mainPos = 0.0;
      case FlexEnd:
        mainPos = totalFlex > 0.0 ? 0.0 : availableMainAxis - childrenMainSizeFixed;
      case Center:
        mainPos = totalFlex > 0.0 ? 0.0 : (availableMainAxis - childrenMainSizeFixed) / 2.0;
      case SpaceBetween:
        mainPos = 0.0;
        spacing = totalFlex > 0.0 || children.length <= 1 ? 0.0 : (availableMainAxis - childrenMainSizeFixed) / (children.length - 1);
      case SpaceAround:
        spacing = totalFlex > 0.0 ? 0.0 : (availableMainAxis - childrenMainSizeFixed) / (children.length + 1);
        mainPos = spacing;
      case SpaceEvenly:
        // Not sure what this is?
    }
    var crossPos = 0.0;

    for (item in children) {
      item.item.layoutPosition = {
        left: 0.0,
        top: 0.0,
      };

      setChildMainPos(item.item, mainPos);

      var childSizeMain = direction == Row || direction == RowReverse ? item.item.layoutSize.width : item.item.layoutSize.height;
      var childSizeCross = direction == Row || direction == RowReverse ? item.item.layoutSize.height : item.item.layoutSize.width;

      mainPos += childSizeMain + spacing;

      if (alignItems == Center) {
        setChildCrossPos(item.item, (availableCrossAxis - childSizeCross) / 2.0);
      } else if (alignItems == Stretch) {
        setChildCrossSize(item.item, availableCrossAxis);
        setChildCrossPos(item.item, 0);
      } else if (alignItems == FlexEnd) {
        setChildCrossPos(item.item, availableCrossAxis - childSizeCross);
      }
    }
  }


  private function setChildMainSize(child:ILayoutObject, size:Float) {
    if (direction == Row || direction == RowReverse) {
      child.layoutSize.width = size;
    } else {
      child.layoutSize.height = size;
    }
  }

  private function setChildCrossSize(child:ILayoutObject, size:Float) {
    if (direction == Row || direction == RowReverse) {
      child.layoutSize.height = size;
    } else {
      child.layoutSize.width = size;
    }
  }

  private function setChildMainPos(child:ILayoutObject, pos:Float) {
    if (direction == Row || direction == RowReverse) {
      child.layoutPosition.left = pos;
    } else {
      child.layoutPosition.top = pos;
    }
  }

  private function setChildCrossPos(child:ILayoutObject, pos:Float) {
    if (direction == Row || direction == RowReverse) {
      child.layoutPosition.top = pos;
    } else {
      child.layoutPosition.left = pos;
    }
  }
}