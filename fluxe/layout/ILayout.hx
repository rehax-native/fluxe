package fluxe.layout;

interface ILayout {
  function layout(items:Array<ILayoutObject>):LayoutSize;
}