package views;

abstract Color(cpp.UInt32) {}

abstract PaintStyle(cpp.UInt8) {
    var Fill = 0;
    var Stroke = 1;
    var StrokeAndFill = 2;
}

extern class Rect {
    extern public static function MakeXYWH(x:Float, y:Float, w:Float, h:Float):Rect;
    extern public function offset(dx:Float, dy:Float);
}

extern class RRect {
    extern public function setOval(rect:Rect);
    extern public function offset(dx:Float, dy:Float);
}

extern class Paint {
    extern public function setStyle(style:PaintStyle);
    extern public function setAntiAlias(antiAlias:Bool);
    extern public function setStrokeWidth(width:Float);
    extern public function setColor(color:Color);
}

extern class Canvas {
    extern public function drawColor(color:Color);
    extern public function drawRect(rect:Rect, paint:Paint);
    extern public function drawRRect(rrect:RRect, paint:Paint);
    extern public function drawCircle(cx:Float, cy:Float, radius:Float);
    extern public function drawRoundRect(rect:Rect, rx:Float, ry:Float, paint:Paint);
}
