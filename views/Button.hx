package views;

enum ButtonState {
    Up;
    Down;
    Hover;
    Disabled;
}

class Button extends View {
    public var title:Text;
    public var padding:Padding;

    public new() {
        this.title = new Text();
    }

    public override measureLayout() {
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
        var oval = new RRect();
        oval.setOval(Rect::MakeXYWH(0, 0, 100, 20));
        builder.canvas.drawRect(oval, Paint::MakeColor(0xFF000000));
        // draw text
    }
}