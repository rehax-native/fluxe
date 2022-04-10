package fluxe.layout;

using fluxe.layout.LayoutConstraint;

class StackLayout implements ILayout {
  public function new() {}
  public var spacing(default, set) = 0.0;

  public function set_spacing(spacing:Float):Float {
    this.spacing = spacing;
    // needsRerender = true;
    return spacing;
  }

  public function layout(items:Array<ILayoutObject>):LayoutSize {
    var y:Float = spacing;
    var maxWidth:Float = 0;
    var item:ILayoutObject;
    for (item in items) {
      item.measureLayout();
      LayoutConstraintSetter.applyLayoutConstraints(item);
      item.layoutPosition = {
        left: spacing,
        top: y,
      };
      y += item.layoutSize.height + spacing;
      maxWidth = Math.max(maxWidth, item.layoutSize.width);
    }

    return { width: maxWidth, height: y };
  }
}