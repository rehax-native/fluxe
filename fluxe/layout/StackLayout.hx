package fluxe.layout;

using fluxe.layout.LayoutConstraint;

enum StackLayoutDirection {
  Vertical;
  Horizontal;
}

class StackLayout implements ILayout {
  public function new() {}
  public var spacing(default, set) = 0.0;

  public function set_spacing(spacing:Float):Float {
    this.spacing = spacing;
    // needsRerender = true;
    return spacing;
  }

  public var layoutDirection(default, set):StackLayoutDirection = Vertical;

  public function set_layoutDirection(layoutDirection:StackLayoutDirection):StackLayoutDirection {
    this.layoutDirection = layoutDirection;
    // needsRerender = true;
    return layoutDirection;
  }

  public function layout(parent: ILayoutObject, items:Array<ILayoutObject>):LayoutSize {
    var pos:Float = spacing;
    var maxCross:Float = 0;
    for (item in items) {
      item.measureLayout();
      LayoutConstraintSetter.applyLayoutConstraints(item);
      if (layoutDirection == Vertical) {
        item.layoutPosition = {
          left: spacing,
          top: pos,
        };
        pos += item.layoutSize.height + spacing;
        maxCross = Math.max(maxCross, item.layoutSize.width + spacing * 2.0);
      } else {
        item.layoutPosition = {
          left: pos,
          top: spacing,
        };
        pos += item.layoutSize.width + spacing;
        maxCross = Math.max(maxCross, item.layoutSize.width + spacing * 2.0);
      }
    }

    if (layoutDirection == Vertical) {
      return { width: maxCross, height: pos };
    } else {
      return { width: pos, height: maxCross };
    }
  }
}