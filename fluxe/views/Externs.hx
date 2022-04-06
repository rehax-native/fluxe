package fluxe.views;

abstract Color(cpp.UInt32) {
    inline public function new(i:cpp.UInt32) {
        this = i;
    }

    static public function RGBA(r:Float, g:Float, b:Float, a:Float):Color {
        var nr = Std.int(r * 255.0);
        var ng = Std.int(g * 255.0);
        var nb = Std.int(b * 255.0);
        var na = Std.int(a * 255.0);
        var color:cpp.UInt32 = (na << 24) | (nr << 16) | (ng << 8) | nb;
        return new Color(color);
    }
}

@:include("render_backend/skia/canvas.h")
@:structAccess
@:native("fluxe::Paint::Style")
extern class NativePaintStyle {
}

class PaintStyle {
    public static var Stroke:NativePaintStyle = untyped __cpp__("fluxe::Paint::Style::kStroke_Style");
    public static var Fill:NativePaintStyle = untyped __cpp__("fluxe::Paint::Style::kFill_Style");
    public static var StrokeAndFill:NativePaintStyle = untyped __cpp__("fluxe::Paint::Style::kStrokeAndFill_Style");
}

@:include("render_backend/skia/canvas.h")
@:native("sk_sp<fluxe::Typeface>")
@:structAccess
extern class Typeface {
    @:native("fluxe::Typeface::MakeDefault")
    public static function MakeDefault():Typeface;
}

@:include("render_backend/skia/canvas.h")
@:native("fluxe::Font")
@:structAccess
extern class Font {
    @:native("fluxe::Font")
    extern public static function Create(typeface:Typeface, size:cpp.Float64):Font;
}

@:include("render_backend/skia/canvas.h")
@:native("sk_sp<fluxe::TextBlob>")
@:structAccess
extern class TextBlob {
    @:native("fluxe::TextBlob::MakeFromString")
    public static function MakeFromString(text:String, font:Font):TextBlob;
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
    extern public function setStyle(style:NativePaintStyle):Void;
    extern public function setAntiAlias(antiAlias:Bool):Void;
    extern public function setDither(dither:Bool):Void;
    extern public function setStrokeWidth(width:Float):Void;
    extern public function setColor(color:Color):Void;
}

@:build(fluxe.views.Build.config())
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
    extern public function drawTextBlob(blob:TextBlob, x:cpp.Float64, y:cpp.Float64, paint:Paint):Void;

    extern public function translate(dx:cpp.Float32, dy:cpp.Float32):Void;
    extern public function scale(sx:cpp.Float32, sy:cpp.Float32):Void;
}

class Canvas {
    public var _canvas:cpp.Pointer<NativeCanvas>;
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
    public function drawTextBlob(blob:TextBlob, x:Float, y:Float, paint:Paint):Void {
        _canvas.ptr.drawTextBlob(blob, x, y, paint);
    }
    public function translate(dx:Float, dy:Float):Void {
        _canvas.ptr.translate(dx, dy);
    }
    public function scale(sx:Float, sy:Float):Void {
        _canvas.ptr.scale(sx, sy);
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
    public var _surface:Null<NativeSurface>;
    public function new(width:Int, height:Int) {
        var scale = 2.0; // TODO this scale should come from the shell
        _surface = NativeSurface.Create(Std.int(width * scale), Std.int(height * scale));
        var canvas = _surface.getCanvas();
        canvas.ptr.scale(scale, scale);
    }
    public function getCanvas():Canvas {
        var canvas = _surface.getCanvas();
        return new Canvas(canvas);
    }

    public function destroy() {
        this._surface = untyped __cpp__ ("nullptr");
    }
}
