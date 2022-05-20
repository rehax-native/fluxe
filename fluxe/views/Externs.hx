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

@:native("SkTileMode")
@:unreflective
@:enum extern abstract ShaderTileMode(String) to String {
    var kClamp;
    var kRepeat;
    var kMirror;
    var kDecal;
}

@:include("render_backend/skia/canvas.h")
@:structAccess
@:native("SkPoint")
@:unreflective
extern class NativePoint {
    public static function Make(x:cpp.Float64, y:cpp.Float64):NativePoint;
}

@:include("render_backend/skia/canvas.h")
@:structAccess
@:native("sk_sp<SkShader>")
@:unreflective
extern class Shader {
}

typedef LinearGradientShaderDefinition = {
    var point0:NativePoint;
    var point1:NativePoint;
    var colors:Array<Color>;
    var positions:Array<cpp.Float32>;
    // var mode:ShaderTileMode;
}

typedef RadialGradientShaderDefinition = {
    var center:NativePoint;
    var radius:cpp.Float64;
    var colors:Array<Color>;
    var positions:Array<cpp.Float32>;
    // var mode:ShaderTileMode;
}

class GradientShader {
    static public function MakeLinear(def:LinearGradientShaderDefinition):Shader {
        var count = def.colors.length;

        // untyped __cpp__('SkPoint * pts = new SkPoint[2];');
        // untyped __cpp__('SkColor * colors = new SkColor[count]');
        // untyped __cpp__('SkScalar * positions = new SkScalar[count]');
        untyped __cpp__('SkPoint pts[2]');
        untyped __cpp__('SkColor colors[count]');
        untyped __cpp__('SkScalar positions[count]');

        var pt0 = def.point0;
        var pt1 = def.point1;
        untyped __cpp__('pts[0] = pt0');
        untyped __cpp__('pts[1] = pt1');
        for (i in 0...count) {
            var col = def.colors[i];
            var pos = def.positions[i];
            untyped __cpp__('colors[i] = col');
            untyped __cpp__('positions[i] = pos');
        }
        // var gradient = GradientShader.MakeLinear(untyped __cpp__('pts'), colors, pos, 3, ShaderTileMode.kClamp);
        // var gradient = GradientShader.MakeLinear(untyped __cpp__('pts'), colors, pos, 3, ShaderTileMode.kClamp);
        // var cols = cpp.Pointer.ofArray(def.colors).constRaw;
        // var pos = cpp.Pointer.ofArray(def.positions).constRaw;
        // var mode = def.mode;
        var gradient = untyped __cpp__('SkGradientShader::MakeLinear(pts, colors, positions, count, SkTileMode::kClamp)');
        return gradient;
    }

    static public function MakeRadial(def:RadialGradientShaderDefinition):Shader {
        var count = def.colors.length;

        untyped __cpp__('SkColor colors[count]');
        untyped __cpp__('SkScalar positions[count]');
        // untyped __cpp__('SkColor * colors = new SkColor[count]');
        // untyped __cpp__('SkScalar * positions = new SkScalar[count]');

        var center = def.center;
        var radius = def.radius;
        for (i in 0...count) {
            var col = def.colors[i];
            var pos = def.positions[i];
            untyped __cpp__('colors[i] = col');
            untyped __cpp__('positions[i] = pos');
        }
        var gradient = untyped __cpp__('SkGradientShader::MakeRadial(center, radius, colors, positions, count, SkTileMode::kClamp)');
        return gradient;
    }
}

@:include("render_backend/skia/canvas.h")
@:structAccess
@:native("fluxe::Paint::Style")
@:unreflective
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
@:native("sk_sp<fluxe::ImageFilter>")
@:structAccess
extern class ImageFilter {
    @:native("sk_sp<fluxe::ImageFilter>")
    extern public static function Create():ImageFilter;
}

@:include("render_backend/skia/canvas.h")
@:native("fluxe::ImageFilters")
@:structAccess
extern class ImageFilters {
    extern public static function Blur(sigmaX:cpp.Float64, sigmaY:cpp.Float64, input:ImageFilter):ImageFilter;
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
    extern public function setImageFilter(imageFilter:ImageFilter):Void;
    extern public function setShader(shader:Shader):Void;
    extern public function setStrokeMiter(miter:cpp.Float64):Void;
}

enum PaintStrokeJoin {
    Miter;
    Round;
    Bevel;
}

enum PaintStrokeCap {
    Butt;
    Round;
    Square;
}

class PaintUtil {
    static public inline function setStrokeJoin(paint:Paint, strokeJoin:PaintStrokeJoin) {
        switch (strokeJoin) {
            case Miter:
                untyped __cpp__('paint.setStrokeJoin(SkPaint::kMiter_Join)');
            case Round:
                untyped __cpp__('paint.setStrokeJoin(SkPaint::kRound_Join)');
            case Bevel:
                untyped __cpp__('paint.setStrokeJoin(SkPaint::kBevel_Join)');
        }
    }
    static public inline function setStrokeCap(paint:Paint, strokeCap:PaintStrokeCap) {
        switch (strokeCap) {
            case Butt:
                untyped __cpp__('paint.setStrokeCap(SkPaint::kButt_Cap)');
            case Round:
                untyped __cpp__('paint.setStrokeCap(SkPaint::kRound_Cap)');
            case Square:
                untyped __cpp__('paint.setStrokeCap(SkPaint::kSquare_Cap)');
        }
    }
}

@:native("fluxe::PathDirection")
@:enum extern abstract PathDirection(String) to String {
    var kCW;
    var kCCW;
}

@:native("fluxe::ArcSize")
@:enum extern abstract ArcSize(String) to String {
    var kSmall_ArcSize;
    var kLarge_ArcSize;
}

@:include("render_backend/skia/canvas.h")
@:native("fluxe::Path")
@:unreflective
@:structAccess
extern class Path {
    extern public function new();
    extern public function moveTo(x:cpp.Float64, y:cpp.Float64):Void;
    extern public function rMoveTo(dx:cpp.Float64, dy:cpp.Float64):Void;
    extern public function lineTo(x:cpp.Float64, y:cpp.Float64):Void;
    extern public function rLineTo(dx:cpp.Float64, dy:cpp.Float64):Void;
    extern public function cubicTo(x1:cpp.Float64, y1:cpp.Float64, x2:cpp.Float64, y2:cpp.Float64, x3:cpp.Float64, y3:cpp.Float64):Void;
    extern public function quadTo(x1:cpp.Float64, y1:cpp.Float64, x:cpp.Float64, y:cpp.Float64):Void;
    extern public function arcTo1(oval:Rect, startAngle:cpp.Float64, sweepAngle:cpp.Float64, forceMoveTo:Bool):Void;
    extern public function arcTo2(x1:cpp.Float64, y1:cpp.Float64, x2:cpp.Float64, y2:cpp.Float64, radius:cpp.Float64):Void;
    extern public function arcTo(rx:cpp.Float64, ry:cpp.Float64, xAxisRotate:cpp.Float64, largeArc:ArcSize, sweep:PathDirection, x:cpp.Float64, y:cpp.Float64):Void;
    extern public function rArcTo(rx:cpp.Float64, ry:cpp.Float64, xAxisRotate:cpp.Float64, largeArc:ArcSize, sweep:PathDirection, dx:cpp.Float64, dy:cpp.Float64):Void;
    extern public function close():Void;
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

    extern public function drawLine(x0:cpp.Float64, y0:cpp.Float64, x1:cpp.Float64, y1:cpp.Float64, paint:Paint):Void;
    extern public function drawOval(oval:Rect, paint:Paint):Void;
    extern public function drawArc(oval:Rect, startAngle:cpp.Float64, sweepAngle:cpp.Float64, useCenter:Bool, paint:Paint):Void;
    extern public function drawPath(path:Path, paint:Paint):Void;
    // extern public function drawImage(const SkImage* image, left:cpp.Float64, top:cpp.Float64):Void;
    // extern public function drawImageNine(const SkImage* image, const SkIRect& center, const SkRect& dst, SkFilterMode filter, paint:cpp.Pointer<Paint>):Void;

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
    public function drawLine(x0:Float, y0:Float, x1:Float, y1:Float, paint:Paint):Void {
        _canvas.ptr.drawLine(x0, y0, x1, y1, paint);
    }
    public function drawOval(oval:Rect, paint:Paint):Void {
        _canvas.ptr.drawOval(oval, paint);
    }
    public function drawArc(oval:Rect, startAngle:Float, sweepAngle:Float, useCenter:Bool, paint:Paint):Void {
        _canvas.ptr.drawArc(oval, startAngle, sweepAngle, useCenter, paint);
    }
    public function drawPath(path:Path, paint:Paint):Void {
        _canvas.ptr.drawPath(path, paint);
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
    public function new(width:Int, height:Int, scale:Float) {
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
