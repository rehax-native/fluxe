package layout;

class StackLayout implements ILayout {
  public function new() {}
  public function layout(items:Array<ILayoutObject>):LayoutSize {
    var x:Float = 0;
    var y:Float = 0;
    var maxHeight:Float = 0;
    var maxWidth:Float = 0;
    var item:ILayoutObject;
    for (item in items) {
      item.measureLayout();
      item.layoutPosition = {
        left: 0,
        top: y,
      };
      y += item.layoutSize.height;
      maxWidth = Math.max(maxWidth, item.layoutSize.width);
      maxHeight = Math.max(maxHeight, item.layoutSize.height);
    }

    return { width: maxWidth, height: y };
  }
}