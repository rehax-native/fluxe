package fluxe.layout;

using fluxe.layout.LayoutConstraint;
using fluxe.layout.LayoutTypes;

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

  private function reduceConstraintsWidth(constraints:LayoutConstraint, amount:Null<Float>) {
    if (constraints.maxWidth != null && amount != null) {
      constraints.maxWidth -= amount;
    }
  }

  private function reduceConstraintsHeight(constraints:LayoutConstraint, amount:Null<Float>) {
    if (constraints.maxHeight != null && amount != null) {
      constraints.maxHeight -= amount;
    }
  }

  public function layout(constraints:LayoutConstraint, parentSize:PossibleLayoutSize, parent: ILayoutObject, items:Array<ILayoutObject>):LayoutSize {
    var pos:Float = spacing;
    var maxCross:Float = 0;
    var nextConstraints = {
      maxWidth: constraints.maxWidth,
      maxHeight: constraints.maxHeight,
      minWidth: constraints.minWidth,
      minHeight: constraints.minHeight,
    };
    for (item in items) {
      item.measureLayout(constraints, parentSize);
      var overrideResult = LayoutConstraintSetter.handleLayoutOverride(nextConstraints, parentSize, item);
      LayoutConstraintSetter.applyLayoutConstraints(item, constraints);
      if (layoutDirection == Vertical) {
        if (overrideResult.hasSizeVertically) {
          item.layoutPosition = {
            left: spacing,
            top: pos,
          };
          pos += item.layoutSize.height + spacing;
          reduceConstraintsHeight(nextConstraints, item.layoutSize.height);
        }
        maxCross = Math.max(maxCross, item.layoutSize.width + spacing * 2.0);
      } else {
        if (overrideResult.hasSizeHorizontally) {
          item.layoutPosition = {
            left: pos,
            top: spacing,
          };
          pos += item.layoutSize.width + spacing;
          reduceConstraintsWidth(nextConstraints, item.layoutSize.width);
        }
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