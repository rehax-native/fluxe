package views;

typedef Window = cpp.RawPointer<Void>;

abstract Color(cpp.UInt32) {
    inline public function new(i:cpp.UInt32) {
        this = i;
    }
}

@:enum
abstract PaintStyle(cpp.UInt8) {
    var Fill = 0;
    var Stroke = 1;
    var StrokeAndFill = 2;
}

@:include("render_backend/skia/canvas.h")
@:native("fluxe::Rect")
@:structAccess
extern class Rect {
    extern public static function MakeXYWH(x:Float, y:Float, w:Float, h:Float):Rect;
    extern public function offset(dx:Float, dy:Float):Void;
}

@:include("render_backend/skia/canvas.h")
@:native("fluxe::RRect")
@:structAccess
extern class RRect {
    extern public function new();
    extern public static function MakeEmpty():RRect;
    extern public static function MakeRect(rect:Rect):RRect;
    extern public static function MakeOval(rect:Rect):RRect;
    extern public static function MakeRectXY(rect:Rect, xRad:Float, yRad:Float):RRect;

    extern public function setOval(rect:Rect):Void;
    extern public function offset(dx:Float, dy:Float):Void;
}

@:include("render_backend/skia/canvas.h")
@:native("fluxe::Paint")
@:structAccess
extern class Paint {
    extern public function new();
    extern public function setStyle(style:PaintStyle):Void;
    extern public function setAntiAlias(antiAlias:Bool):Void;
    extern public function setStrokeWidth(width:Float):Void;
    extern public function setColor(color:Color):Void;
}

@:buildXml("
    <files id=\"haxe\">
        <compilerflag value=\"-std=c++20\" />
        <compilerflag value=\"-stdlib=libc++\" />
        <compilerflag value=\"-mmacosx-version-min=10.9\" />
        <compilerflag value=\"-I../../..\" />
        <compilerflag value=\"-I../../../third_party/skia\" />
        <compilerflag value=\"-I../../../third_party/skia/include/core\" />
    </files>
    <files id=\"__main__\">
        <compilerflag value=\"-std=c++20\" />
        <compilerflag value=\"-stdlib=libc++\" />
        <compilerflag value=\"-mmacosx-version-min=10.9\" />
    </files>
    <files id=\"__lib__\">
        <compilerflag value=\"-std=c++20\" />
        <compilerflag value=\"-stdlib=libc++\" />
        <compilerflag value=\"-mmacosx-version-min=10.9\" />
    </files>
    <files id=\"runtime\">
        <compilerflag value=\"-std=c++14\" />
        <compilerflag value=\"-stdlib=libc++\" />
        <compilerflag value=\"-mmacosx-version-min=10.9\" />
    </files>
    <target id=\"haxe\" tool=\"linker\" toolid=\"exe\">
        <lib name=\"-lskia\" />
    </target>
")
@:include("render_backend/skia/canvas.h")
@:native("fluxe::Canvas")
extern class NativeCanvas {
    @:native("new fluxe::Canvas")
    public static function Create():cpp.Pointer<NativeCanvas>;
    extern public function drawColor(color:Color):Void;
    extern public function drawRect(rect:Rect, paint:Paint):Void;
    extern public function drawRRect(rrect:RRect, paint:Paint):Void;
    extern public function drawCircle(cx:cpp.Float64, cy:cpp.Float64, radius:cpp.Float64, paint:Paint):Void;
    extern public function drawRoundRect(rect:Rect, rx:cpp.Float64, ry:cpp.Float64, paint:Paint):Void;
}

class Canvas {
    var _canvas:cpp.Pointer<NativeCanvas>;
    public function new() {
        _canvas = NativeCanvas.Create();
    }
    public function drawColor(color:Color):Void {
        _canvas.ptr.drawColor(color);
    }
    public function drawRect(rect:Rect, paint:Paint):Void {
        _canvas.ptr.drawRect(rect, paint);
    }
    public function drawRRect(rrect:RRect, paint:Paint):Void {
        _canvas.ptr.drawRRect(rrect, paint);
    }
    public function drawCircle(cx:Float, cy:Float, radius:Float, paint:Paint):Void {
        _canvas.ptr.drawCircle(cx, cy, radius, paint);
    }
    public function drawRoundRect(rect:Rect, rx:Float, ry:Float, paint:Paint):Void {
        _canvas.ptr.drawRoundRect(rect, rx, ry, paint);
    }
}

@:include("engine.h")
@:native("fluxe::Engine")
extern class Engine {
    @:native("new fluxe::Engine")
    public static function Create():cpp.Pointer<Engine>;

    extern public function createPlatformWindow():Window;
    extern public function attachToPlatformWindow(window:Window):Void;
    extern public function renderCanvas(canvas:Canvas):Void;
    extern public function startMainLoop():Void;
    extern public function detachFromPlatformWindow():Void;
    extern public function closePlatformWindow(window:Window):Void;
}

class EngineUtility {
    public static function startWithView(view:View):Void {
        var engine = Engine.Create();
        var window = engine.ptr.createPlatformWindow();
        engine.ptr.attachToPlatformWindow(window);
        // engine.ptr.setRootView(view);
        engine.ptr.startMainLoop();
        engine.ptr.detachFromPlatformWindow();
        engine.ptr.closePlatformWindow(window);
        engine.destroy();
    }
}