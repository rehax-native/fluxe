package views;

using layout.Padding;
using views.Externs;
using events.MouseEventsManager;
using events.FocusManager;

enum ButtonState {
    Up;
    Down;
    Hover;
    Disabled;
}

class Button extends View implements IMouseDownListener implements IMouseUpListener implements IFocusable {
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

    public var onClick:(button:Button) -> Void = (btn:Button) -> {};

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

        if (this.state == ButtonState.Up) {
            paint.setColor(Color.RGBA(0.2, 0.2, 0.2, 0.6));
        } else if (this.state == ButtonState.Down) {
            paint.setColor(Color.RGBA(0.2, 0.2, 0.2, 0.2));
        // } else if (this.state == ButtonState.Hover) {
        //     paint.setColor(Color.RGBA(0.8, 0.8, 0.8, 0.8));
        // } else if (this.state == ButtonState.Disabled) {
        //     paint.setColor(Color.RGBA(0.6, 0.6, 0.6, 0.8));
        }

        paint.setStyle(PaintStyle.Fill);
        builder.canvas.drawRRect(rrect, paint);
    }

    public function onMouseDown(event:MouseDownEvent):Void {
        this.viewManager.focusManager.gainFocus(this);
        this.state = ButtonState.Down;
        this.needsRerender = true;
    }

    public function onMouseUp(event:MouseUpEvent):Void {
        this.state = ButtonState.Up;
        this.needsRerender = true;

        onClick(this);
    }

    public function didGainFocus():Void {
    }

    public function didLoseFocus():Void {
    }
}