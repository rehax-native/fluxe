
class StackLayout implements ILayout {
  function layout(items:Array<ILayoutObject>):LayoutSize {
    var x:Float = 0;
    var y:Float = 0;
    var maxHeight:Float = 0;
    var maxWidth:Float = 0;
    var item:ILayoutObject;
    for (var i:Number = 0; i < items.length; i++) {
      item = items[i];
      item.measureLayout();
      item.layoutPosition = {
        left: 0,
        top: y,
      };
      y += item.layoutSize.height;
      maxHeight = Math.max(maxHeight, item.getHeight());
      maxWidth = Math.max(maxWidth, item.getWidth());
    }

    return { width: maxWidth, height: maxHeight };
  }
}