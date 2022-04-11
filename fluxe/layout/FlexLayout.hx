package fluxe.layout;

using fluxe.layout.LayoutConstraint;

enum FlexDirection {
  Row;
  RowReverse;
  Column;
  ColumnReverse;
}

typedef FlexItem = {
  ?order:Int,
  ?flexGrow:Float,
}

class FlexLayout implements ILayout {
  public function new() {}

  public var itemInfos:Array<FlexItem> = [];

  public var direction(default, set):FlexDirection = Row;

  public function set_direction(direction:FlexDirection):FlexDirection {
    this.direction = direction;
    return direction;
  }

  public function layout(parent: ILayoutObject, items:Array<ILayoutObject>):LayoutSize {
    var zipped:Array<{
      item: ILayoutObject,
      info: FlexItem,
    }> = [];

    var flexSum = 0.0;
    var fullWidth = 0.0;
    var fullHeight = 0.0;
    var availableSize = 0.0;
    if (direction == Row || direction == RowReverse) {
      if (parent.layoutConstraints != null && parent.layoutConstraints.explicitWidth != null) {
        availableSize = parent.layoutConstraints.explicitWidth;
      } else if (parent.layoutConstraints != null && parent.layoutConstraints.maxWidth != null) {
        availableSize = parent.layoutConstraints.maxWidth;
      }
    } else {
      if (parent.layoutConstraints != null && parent.layoutConstraints.explicitHeight != null) {
        availableSize = parent.layoutConstraints.explicitHeight;
      } else if (parent.layoutConstraints != null && parent.layoutConstraints.maxHeight != null) {
        availableSize = parent.layoutConstraints.maxHeight;
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

      item.measureLayout();
      LayoutConstraintSetter.applyLayoutConstraints(item);

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
        item.item.layoutPosition = {
          left: pos,
          top: 0,
        };
        if (size != null) {
          item.item.layoutSize.width = size;
        }
        pos += sign * item.item.layoutSize.width;

        if (item.item.layoutSize.height > maxCross) {
          maxCross = item.item.layoutSize.height;
        }
      } else {
        item.item.layoutPosition = {
          left: 0,
          top: pos,
        };
        if (size != null) {
          item.item.layoutSize.height = size;
        }
        pos += sign * item.item.layoutSize.height;

        if (item.item.layoutSize.width > maxCross) {
          maxCross = item.item.layoutSize.width;
        }
      }
    }

    if (direction == Row || direction == RowReverse) {
      return { width: fullSize, height: maxCross };
    } else {
      return { width: maxCross, height: fullSize };
    }
  }
}