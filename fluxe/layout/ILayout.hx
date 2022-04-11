package fluxe.layout;

interface ILayout {
  function layout(parent: ILayoutObject, items:Array<ILayoutObject>):LayoutSize;
}