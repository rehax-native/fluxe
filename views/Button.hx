package views;

using layout.Padding;
using views.Externs;

enum ButtonState {
    Up;
    Down;
    Hover;
    Disabled;
}

class Button extends View {
    public var title:Text;
    public var padding:Padding = {
        left: 10,
        right: 10,
        top: 5,
        bottom: 5,
    };
    
    private var state:ButtonState = ButtonState.Up;

    public function new() {
        super();
        this.title = new Text();
        this.addSubView(title);
    }

    public override function measureLayout() {
        this.title.measureLayout();
        this.layoutSize = {
            width: this.title.layoutSize.width + this.padding.left + this.padding.right,
            height: this.title.layoutSize.height + this.padding.top + this.padding.bottom,
        };
        this.title.layoutPosition = {
            left: this.padding.left,
            top: this.padding.top,
        };
    }

    public override function build(builder:ViewBuilder) {
        var rrect = RRect.MakeRectXY(Rect.MakeXYWH(0, 0, this.layoutSize.width, this.layoutSize.height), 5, 5);

        var paint = new Paint();
        paint.setAntiAlias(true);
        paint.setColor(Color.RGBA(0.6, 0.6, 0.6, 0.8));
        paint.setStyle(PaintStyle.Stroke);
        builder.canvas.drawRRect(rrect, paint);

        paint.setColor(Color.RGBA(0.2, 0.2, 0.2, 0.6));
        paint.setStyle(PaintStyle.Fill);
        builder.canvas.drawRRect(rrect, paint);
    }
}