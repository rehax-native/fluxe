package views;

class Text extends View {

    public function new() {
        super();
    }

    public var text = "";

    public override function measureLayout() {
        this.layoutSize = {
            width: 100,
            height: 15,
        };
    }

    public override function build(builder:ViewBuilder) {
        // builder.canvas.drawText(this.text, 0, 0, Paint.MakeColor(0xFFFFFFFF));
    }
}