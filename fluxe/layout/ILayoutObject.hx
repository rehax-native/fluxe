package fluxe.layout;

using fluxe.layout.LayoutTypes;

interface ILayoutObject {
  var layoutSize:Null<LayoutSize>;
  var layoutPosition:Null<LayoutPosition>;

  var layoutSizeOverride:Null<LayoutSizeOverride>;
  var layoutPositionOverride:Null<LayoutPositionOverride>;

  function measureLayout(constraints:LayoutConstraint, parentSize:PossibleLayoutSize):Void;
}
