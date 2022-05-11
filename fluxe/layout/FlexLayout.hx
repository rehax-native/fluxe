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

  public function layout(constraints:LayoutConstraint, parentSize:PossibleLayoutSize, parent: ILayoutObject, items:Array<ILayoutObject>):LayoutSize {
    var zipped:Array<{
      item: ILayoutObject,
      info: FlexItem,
    }> = [];

    var flexSum = 0.0;
    var fullWidth = 0.0;
    var fullHeight = 0.0;
    var availableSize = 0.0;

    var nextConstraints = {
      maxWidth: constraints.maxWidth,
      maxHeight: constraints.maxHeight,
      minWidth: constraints.minWidth,
      minHeight: constraints.minHeight,
    };

    if (direction == Row || direction == RowReverse) {
      if (parentSize.width != null) {
        availableSize = parentSize.width;
      }
    } else {
      if (parentSize.height != null) {
        availableSize = parentSize.height;
      }
    }
    var fullSize = availableSize;
    var maxCross = 0.0;

    for (i in 0...items.length) {
      var item = items[i];
      var info = i < itemInfos.length ? itemInfos[i] : {
        order: 0,
      };
      if (info.order == null) {
        info.order = 0;
      }

      item.measureLayout(constraints, parentSize);

      var overrideResult = LayoutConstraintSetter.handleLayoutOverride(nextConstraints, parentSize, item);
      LayoutConstraintSetter.applyLayoutConstraints(item, constraints);

      if (info.flexGrow != null) {
        flexSum += info.flexGrow;
      } else {
        availableSize -= direction == Row || direction == RowReverse ? item.layoutSize.width : item.layoutSize.height;
      }

      fullWidth += item.layoutSize.width;
      fullHeight += item.layoutSize.height;

      zipped.push({
        item: item,
        info: info
      });

      if (direction == Row || direction == RowReverse) {
        if (item.layoutSize.height > maxCross) {
          maxCross = item.layoutSize.height;
        }
      } else {
        if (item.layoutSize.width > maxCross) {
          maxCross = item.layoutSize.width;
        }
      }
    }

    zipped.sort((a, b) -> {
      return a.info.order - b.info.order;
    });

    if (flexSum == 0.0) {
      flexSum = 1.0;
    }

    var pos = 0.0;

    var sign = 1.0;
    if (direction == RowReverse) {
      pos = fullWidth;
      sign = -1.0;
    } else if (direction == ColumnReverse) {
      pos = fullHeight;
      sign = -1.0;
    }

    for (item in zipped) {
      var size:Null<Float> = null;
      if (item.info.flexGrow != null) {
        size = availableSize / flexSum * item.info.flexGrow;
      }

      if (direction == Row || direction == RowReverse) {
        var crossPos = 0.0;
        if (alignItems == Center) {
          crossPos = (maxCross - item.item.layoutSize.height) / 2.0;
        } else if (alignItems == Stretch) {
          // todo this should layout the item with the full available size
          crossPos = 0.0;
          item.item.layoutSize.height = maxCross;
        } else if (alignItems == FlexEnd) {
          crossPos = maxCross - item.item.layoutSize.height;
        }
        item.item.layoutPosition = {
          left: pos,
          top: crossPos,
        };
        if (size != null) {
          item.item.layoutSize.width = size;
        }
        pos += sign * item.item.layoutSize.width;
      } else {
        var crossPos = 0.0;
        if (alignItems == Center) {
          crossPos = (maxCross - item.item.layoutSize.width) / 2.0;
        } else if (alignItems == Stretch) {
          // todo this should layout the item with the full available size
          crossPos = 0.0;
          item.item.layoutSize.width = maxCross;
        } else if (alignItems == FlexEnd) {
          crossPos = maxCross - item.item.layoutSize.width;
        }
        item.item.layoutPosition = {
          left: crossPos,
          top: pos,
        };
        if (size != null) {
          item.item.layoutSize.height = size;
        }
        pos += sign * item.item.layoutSize.height;
      }
    }

    if (direction == Row || direction == RowReverse) {
      return { width: fullSize, height: maxCross };
    } else {
      return { width: maxCross, height: fullSize };
    }
  }
}