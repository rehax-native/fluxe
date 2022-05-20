package examples.paths;

using fluxe.views.View;
using fluxe.views.ViewBuilder;
using fluxe.views.Button;
using fluxe.views.Text;
using fluxe.views.TextInput;
using fluxe.views.Externs;
using fluxe.views.Engine;
using fluxe.layout.StackLayout;
using fluxe.layout.FlexLayout;


class SimpleLine extends View {

    public function new() {
        super();
    }

    public override function measureLayout(constraints:fluxe.layout.LayoutConstraint, parentSize:fluxe.layout.LayoutTypes.PossibleLayoutSize) {
        this.layoutSize = {
            width: 50,
            height: 30,
        };
    }

    public override function build(builder:ViewBuilder) {
        var paint = new Paint();
        paint.setAntiAlias(true);
        paint.setColor(Color.RGBA(1.0, 0.6, 0.6, 0.8));
        paint.setStyle(PaintStyle.Stroke);

        var path = new Path();
        path.moveTo(20, 10);
        path.lineTo(40, 20);

        builder.canvas.drawPath(path, paint);
    }
}

class PathWithArcs extends View {

    public function new() {
        super();
    }

    public override function measureLayout(constraints:fluxe.layout.LayoutConstraint, parentSize:fluxe.layout.LayoutTypes.PossibleLayoutSize) {
        this.layoutSize = {
            width: 100,
            height: 100,
        };
    }

    public override function build(builder:ViewBuilder) {
        var paint = new Paint();
        paint.setAntiAlias(true);
        paint.setColor(Color.RGBA(1.0, 1.0, 0.6, 0.8));
        paint.setStyle(PaintStyle.Stroke);
        paint.setStrokeWidth(2.0);
        paint.setStrokeCap(kRound_Cap);
        paint.setStrokeJoin(kRound_Join);

        var path = new Path();
        path.moveTo(20, 10);
        path.lineTo(40, 20);
        path.cubicTo(50, 40, 20, 20, 40, 40);
        path.arcTo(20, 20, 30, kLarge_ArcSize, kCW, 50, 50);

        var gradient = GradientShader.MakeLinear({
            point0: NativePoint.Make(0, 0),
            point1: NativePoint.Make(70, 70),
            colors: [
                Color.RGBA(1.0, 0.0, 0.0, 0.8),
                Color.RGBA(0.0, 0.6, 0.6, 0.8),
                Color.RGBA(1.0, 1.0, 0.6, 0.8),
            ],
            positions: [
                0.0,
                0.6,
                1.0,
            ],
            // mode: ShaderTileMode.kClamp,
        });
        paint.setShader(gradient);

        builder.canvas.drawPath(path, paint);
    }
}

class PathWithArcsAndBlur extends View {

    public function new() {
        super();
    }

    public override function measureLayout(constraints:fluxe.layout.LayoutConstraint, parentSize:fluxe.layout.LayoutTypes.PossibleLayoutSize) {
        this.layoutSize = {
            width: 100,
            height: 100,
        };
    }

    public override function build(builder:ViewBuilder) {
        var paint = new Paint();
        paint.setAntiAlias(true);
        paint.setColor(Color.RGBA(1.0, 1.0, 0.6, 0.8));
        paint.setStyle(PaintStyle.Stroke);
        paint.setStrokeWidth(2.0);

        var imageFilter = ImageFilter.Create();
        imageFilter = ImageFilters.Blur(2, 4, imageFilter);
        paint.setImageFilter(imageFilter);

        var path = new Path();
        path.moveTo(20, 10);
        path.lineTo(40, 20);
        path.cubicTo(50, 40, 20, 20, 40, 40);
        path.arcTo(20, 20, 30, kLarge_ArcSize, kCW, 50, 50);

        builder.canvas.drawPath(path, paint);
    }
}

class Paths {
    public static function main() {
        var paths = new Paths();
        EngineUtility.startWithView(paths.container);
    }

    public var container:View;

    public function new() {
        container = new View();

        var layout = new StackLayout();
        layout.spacing = 10.0;
        container.layout = layout;

        var simpleLine = new SimpleLine();
        container.addSubView(simpleLine);

        var pathWithArcs = new PathWithArcs();
        container.addSubView(pathWithArcs);

        var pathWithArcsAndBlur = new PathWithArcsAndBlur();
        container.addSubView(pathWithArcsAndBlur);
    }
}