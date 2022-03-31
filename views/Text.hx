package views;

using views.Externs;

class Text extends View {

    public function new() {
        super();
    }

    public var text = "";

    public override function measureLayout() {
        this.layoutSize = {
            width: 100,
            height: 34,
        };
    }

    public override function build(builder:ViewBuilder) {
        var paint = new Paint();
        paint.setColor(new Color(0xFFFFFFFF));
        var typeface = Typeface.MakeDefault();
        var font = Font.Create(typeface, 14);
        var blob = TextBlob.MakeFromString(this.text, font);

        builder.canvas.drawTextBlob(blob, 0, 20, paint);
    // public function drawTextBlob(blob:TextBlob, x:Float, y:Float, paint:Paint):Void {
        // builder.canvas.drawText(this.text, 0, 0, Paint.MakeColor(0xFFFFFFFF));
    }
}