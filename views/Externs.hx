package views;

using render_pipeline.RenderPipeline;

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
@:unreflective
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
@:unreflective
@:structAccess
extern class Paint {
    extern public function new();
    extern public function setStyle(style:PaintStyle):Void;
    extern public function setAntiAlias(antiAlias:Bool):Void;
    extern public function setStrokeWidth(width:Float):Void;
    extern public function setColor(color:Color):Void;
}

@:build(views.Build.config())
@:include("render_backend/skia/canvas.h")
@:native("fluxe::Canvas")
@:unreflective
extern class NativeCanvas {
    @:native("new fluxe::Canvas")
    public static function Create():cpp.Pointer<NativeCanvas>;
    extern public function drawColor(color:Color):Void;
    extern public function drawRect(rect:Rect, paint:Paint):Void;
    extern public function drawRRect(rrect:RRect, paint:Paint):Void;
    extern public function drawCircle(cx:cpp.Float64, cy:cpp.Float64, radius:cpp.Float64, paint:Paint):Void;
    extern public function drawRoundRect(rect:Rect, rx:cpp.Float64, ry:cpp.Float64, paint:Paint):Void;
    extern public function translate(dx:cpp.Float32, dy:cpp.Float32):Void;
}

class Canvas {
    var _canvas:cpp.Pointer<NativeCanvas>;
    public function new(?canvas:cpp.Pointer<NativeCanvas>) {
        if (canvas != null) {
            _canvas = canvas;
        } else {
            _canvas = NativeCanvas.Create();
        }
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
    public function translate(dx:Float, dy:Float):Void {
        _canvas.ptr.translate(dx, dy);
    }
}

@:include("render_backend/skia/canvas.h")
@:native("sk_sp<fluxe::Surface>")
@:unreflective
extern class NativeSurface {
    @:native("fluxe::Surface::MakeRasterN32Premul")
    public static function Create(width:Int, height:Int):NativeSurface;
    extern public function getCanvas():cpp.Pointer<NativeCanvas>;
}

class RenderSurface {
    public var _surface:NativeSurface;
    public function new(width:Int, height:Int) {
        _surface = NativeSurface.Create(width, height);
    }
    public function getCanvas():Canvas {
        var canvas = _surface.getCanvas();
        return new Canvas(canvas);
    }
}

@:include("engine.h")
@:native("fluxe::Engine")
extern class Engine {
    @:native("new fluxe::Engine")
    public static function Create():cpp.Pointer<Engine>;

    extern public function createPlatformWindow():Window;
    extern public function attachToPlatformWindow(window:Window):Void;
    // extern public function renderCanvas(canvas:Canvas):Void;
    extern public function setRenderCallback(callback:(width:Int, height:Int) -> NativeSurface):Void;
    extern public function startMainLoop():Void;
    extern public function detachFromPlatformWindow():Void;
    extern public function closePlatformWindow(window:Window):Void;
}

@:unreflective
class EngineUtility {
    public static function startWithView(view:View):Void {
        // var engine = Engine.Create();
        // var window = engine.ptr.createPlatformWindow();
        // engine.ptr.attachToPlatformWindow(window);
        // // engine.ptr.setRootView(view);
        // var pipeline = new RenderPipeline(view);

        // var callback:(width:Int, height:Int) -> NativeSurface = function(width:Int, height:Int) {
        //     var surface = pipeline.render(width, height);
        //     return surface._surface;
        // };
        // engine.ptr.setRenderCallback(callback);
        // engine.ptr.startMainLoop();
        // engine.ptr.detachFromPlatformWindow();
        // engine.ptr.closePlatformWindow(window);
        // engine.destroy();
        var util = new EngineUtility(view);
        trace(util);
    }


    var engine = Engine.Create();
    var pipeline:RenderPipeline;

    private function new(view:View) {
        var window = engine.ptr.createPlatformWindow();
        engine.ptr.attachToPlatformWindow(window);
        pipeline = new RenderPipeline(view);
        untyped __cpp__ ("this->engine->ptr->setRenderCallback([this] (int w, int h) { return this->renderCallback(w, h); })");
        // engine.ptr.setRenderCallback(untyped __cpp__ ("renderCallback"));
        engine.ptr.startMainLoop();
        engine.ptr.detachFromPlatformWindow();
        engine.ptr.closePlatformWindow(window);
        engine.destroy();
    }

    public function renderCallback(width:Int, height:Int):NativeSurface {
        var surface = pipeline.render(width, height);
        return surface._surface;
    }
}