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
    public var padding:Padding;

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
        var paint = new Paint();
        paint.setColor(new Color(0x20FF0020));
        // set paint color
        builder.canvas.drawRRect(RRect.MakeRectXY(Rect.MakeXYWH(0, 0, 100, 20), 5, 5), paint);
        // draw text
    }
}