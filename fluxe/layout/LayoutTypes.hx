package fluxe.layout;

enum SizeDimension {
  /** Natural, meaning the size that the view reports **/
  Natural;

  /** Fixed size in screen independent pixels **/
  Fixed(size:Float);

  /** Fill the parent (looking at the parent's layout constraints) **/
  Fill;

  /** Percentage of parent (looking at the parent's layout constraints) **/
  Percentage(percent:Float);
}

enum PositionDimension {
  /** Natural, meaning the position set by the layout **/
  Natural;

  /** Fixed positin in screen independent pixels, relative to the parent **/
  Fixed(position:Float);

  /** Percentage of parent (looking at the parent's layout constraints) **/
  Percentage(percent:Float);
}

typedef LayoutSizeOverride = {
  var width:Null<SizeDimension>;
  var height:Null<SizeDimension>;
}

typedef LayoutPositionOverride = {
  var left:Null<PositionDimension>;
  var top:Null<PositionDimension>;
  var right:Null<PositionDimension>;
  var bottom:Null<PositionDimension>;
}

typedef PossibleLayoutSize = {
  var width:Null<Float>;
  var height:Null<Float>;
}

typedef LayoutSize = {
  var width:Float;
  var height:Float;
}

typedef LayoutPosition = {
  var left:Float;
  var top:Float;
}
