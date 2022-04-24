package fluxe.layout;

using fluxe.layout.LayoutTypes;

interface ILayout {
  function layout(constraints:LayoutConstraint, parentSize:PossibleLayoutSize, parent: ILayoutObject, items:Array<ILayoutObject>):LayoutSize;
}