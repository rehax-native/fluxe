package fluxe.layout;

interface ILayoutObject {
  var layoutConstraints:Null<LayoutConstraint>;
  var layoutSize:Null<LayoutSize>;
  var layoutPosition:Null<LayoutPosition>;

  function measureLayout():Void;
}