package views;

using views.Externs;
using events.MouseEventsManager;
using events.PressEvent;
using events.ActionEventsManager;
using events.FocusManager;
using layout.Padding;

typedef TextSelectionRange = {
    var start:Int;
    var end:Int;
}

class TextInput extends View implements IFocusable implements IMouseEventListenerContainer implements IPressEventListener implements IActionListener {

    public var mouseEventListeners:Array<IMouseEventListener>;

    public function new() {
        super();
        this.addSubView(text);

        mouseEventListeners = [
            new PressDetector(this),
        ];
    }

    private var text = new Text();
    private var caretTimer:Null<animation.Timer> = null;
    private var isShowingCaret = false;
    private var selectionRange = {
        start: 0,
        end: 0
    };
    private var isFocused = false;
    private var needsCaretUpdate = false;
    public var padding:Padding = {
        left: 10,
        right: 10,
        top: 5,
        bottom: 5,
    };

    public override function measureLayout() {
        this.text.measureLayout();
        var minWidth = 100.0;
        var width = this.text.layoutSize.width + this.padding.left + this.padding.right;
        if (width < minWidth) {
            width = minWidth;
        }
        this.layoutSize = {
            width: width,
            height: this.text.layoutSize.height + this.padding.top + this.padding.bottom,
        };
        this.text.layoutPosition = {
            left: this.padding.left,
            top: this.padding.top,
        };
    }

    private var caretPosition = {
        x: 0.0,
        y: 0.0,
    };
    private var selectionRects:Array<views.Text.TextBox> = [];

    public override function build(builder:ViewBuilder) {
        var rrect = RRect.MakeRectXY(Rect.MakeXYWH(0, 0, this.layoutSize.width, this.layoutSize.height), 5, 5);

        var paint = new Paint();
        paint.setAntiAlias(true);
        paint.setColor(Color.RGBA(0.6, 0.6, 0.6, 0.8));
        paint.setStyle(PaintStyle.Stroke);
        builder.canvas.drawRRect(rrect, paint);

        if (this.isFocused) {
            paint.setColor(Color.RGBA(1.0, 0.6, 0.6, 0.8));
            builder.canvas.drawRRect(rrect, paint);
        //     paint.setColor(Color.RGBA(0.2, 0.2, 0.2, 0.6));
        // } else {
        //     paint.setColor(Color.RGBA(0.2, 0.2, 0.2, 0.2));
        // // } else if (this.state == ButtonState.Hover) {
        // //     paint.setColor(Color.RGBA(0.8, 0.8, 0.8, 0.8));
        // // } else if (this.state == ButtonState.Disabled) {
        // //     paint.setColor(Color.RGBA(0.6, 0.6, 0.6, 0.8));
        }

        paint.setStyle(PaintStyle.Fill);
        paint.setColor(Color.RGBA(1.0, 1.0, 1.0, 0.3));

        if (needsCaretUpdate) {
            var hasSelection = this.selectionRange.start != this.selectionRange.end;
            var startSel = hasSelection ? this.selectionRange.start : 0;

            var rects = this.text.getRectsForRange(startSel, selectionRange.end);
            if (rects.length > 0) {
                var caretRect = rects[rects.length - 1];

                caretPosition = {
                    x: caretRect.right,
                    y: caretRect.top,
                };
            } else {
                caretPosition = {
                    x: 0.0,
                    y: 0.0,
                };
            }
            if (hasSelection) {
                selectionRects = rects;
            } else {
                selectionRects = [];
            }

            needsCaretUpdate = false;
        }

        for (rect in selectionRects) {
            var selRect = Rect.MakeXYWH(this.text.layoutPosition.left + rect.left, this.text.layoutPosition.top + rect.top, rect.right - rect.left, rect.bottom - rect.top);
            builder.canvas.drawRect(selRect, paint);
        }

        if (isShowingCaret) {
            var caretRect = Rect.MakeXYWH(this.text.layoutPosition.left + caretPosition.x, this.text.layoutPosition.top + caretPosition.y, 1, this.text.layoutSize.height);
            paint.setStyle(PaintStyle.Fill);
            paint.setColor(Color.RGBA(1.0, 1.0, 1.0, 1.0));
            builder.canvas.drawRect(caretRect, paint);
        }
    }

    public function didGainFocus():Void {
        this.isFocused = true;
        this.isShowingCaret = false;
        if (caretTimer == null) {
            caretTimer = animation.Timer.startInterval(500, () -> {
                this.isShowingCaret = !this.isShowingCaret;
                this.needsRerender = true;
            });
        }
        this.needsRerender = true;
    }

    public function didLoseFocus():Void {
        this.isFocused = false;
        this.isShowingCaret = false;
        this.needsRerender = true;
        if (caretTimer != null) {
            animation.Timer.stopTimer(caretTimer);
            caretTimer = null;
        }
    }

    public function onPressStarted(event:PressStartedEvent) {
    }

    public function onPressFinished(event:PressFinishedEvent) {
        this.viewManager.focusManager.gainFocus(this);
    }

    public function onPressCanceled(event:PressCanceledEvent) {
    }

    public function onAction(action:Action):Void {
        switch (action) {
            case INSERT_STRING(str):
                this.text.text = this.text.text.substring(0, this.selectionRange.end) + str + this.text.text.substring(this.selectionRange.end);
                this.needsRerender = true;
                this.needsCaretUpdate = true;
                this.selectionRange.end = this.selectionRange.end + 1;
                this.selectionRange.start = this.selectionRange.end;
            case LEFT, BACKWARD:
                this.selectionRange.end = this.selectionRange.end - 1;
                if (this.selectionRange.end < 0) {
                    this.selectionRange.end = 0;
                }
                this.selectionRange.start = this.selectionRange.end;
                this.needsRerender = true;
                this.needsCaretUpdate = true;
            case RIGHT, FORWARD:
                this.selectionRange.end = this.selectionRange.end + 1;
                if (this.selectionRange.end > this.text.text.length) {
                    this.selectionRange.end = this.text.text.length;
                }
                this.selectionRange.start = this.selectionRange.end;
                this.needsRerender = true;
                this.needsCaretUpdate = true;
            case DELETE_FORWARD:
                if (this.selectionRange.end < this.text.text.length) {
                    this.text.text = this.text.text.substring(0, this.selectionRange.end) + this.text.text.substring(this.selectionRange.end + 1);
                    this.needsRerender = true;
                    this.needsCaretUpdate = true;
                    this.selectionRange.end = this.selectionRange.end + 1;
                    this.selectionRange.start = this.selectionRange.end;
                }
            case DELETE_BACKWARD:
                if (this.selectionRange.end > 0) {
                    this.text.text = this.text.text.substring(0, this.selectionRange.end - 1) + this.text.text.substring(this.selectionRange.end);
                    this.needsRerender = true;
                    this.needsCaretUpdate = true;
                    this.selectionRange.end = this.selectionRange.end - 1;
                    this.selectionRange.start = this.selectionRange.end;
                }
            case SELECT_ALL:
                trace('all');
                this.selectionRange.start = 0;
                this.selectionRange.end = this.text.text.length;
                this.needsRerender = true;
                this.needsCaretUpdate = true;
            default:
        }
    }
}