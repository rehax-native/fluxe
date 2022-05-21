package fluxe.views;

using fluxe.views.Externs;
using fluxe.events.MouseEventsManager;
using fluxe.events.PressEvent;
using fluxe.events.ActionEventsManager;
using fluxe.events.FocusManager;
using fluxe.layout.Padding;

typedef TextSelectionRange = {
    var start:Int;
    var end:Int;
}

class TextInput extends View implements IFocusable implements IPressEventListener implements IActionListener {

    public static final NEW_LINE_REGEX = ~/win/i.match(Sys.systemName()) ? ~/\r\n/i : ~/\n/i;

    public function new() {
        super();
        this.addSubView(text);

        mouseEventListeners = [
            new PressDetector(this),
        ];
    }

    private var text = new Text();
    public var value(default, set):String;
    public var onValueChange: (value:String) -> Void = (value:String) -> {};
    private var caretTimer:Null<fluxe.animation.Timer> = null;
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
        top: 7,
        bottom: 7,
    };

    public var isHiddenCharacters(default, set) = false;

    public function set_isHiddenCharacters(hidden:Bool):Bool {
        needsRerender = true;
        text.needsRerender = true;
        return hidden;
    }

    public function get_value():String {
        return this.value;
    }

    public function set_value(value:String):String {
        if (this.value != value) {
            this.value = value;
            if (isHiddenCharacters) {
                text.text = '';
                for (i in 0...value.length) {
                    text.text += '•';
                }
            } else {
                text.text = value;
            }
            onValueChange(value);
        }
        return value;
    }

    public override function measureLayout(constraints:fluxe.layout.LayoutConstraint, parentSize:fluxe.layout.LayoutTypes.PossibleLayoutSize) {
        this.text.measureLayout(constraints, parentSize);
        var minWidth = 100.0;
        var width = this.text.layoutSize.width + this.padding.left + this.padding.right;
        if (width < minWidth) {
            width = minWidth;
        }
        this.layoutSize = {
            width: width,
            height: this.text.layoutSize.height + this.padding.top + this.padding.bottom,
        };
        if (caretHeight < 1.0) {
            caretHeight = this.text.layoutSize.height;
        }
        this.text.layoutPosition = {
            left: this.padding.left,
            top: this.padding.top,
        };
    }

    private var caretPosition = {
        x: 0.0,
        y: 0.0,
    };
    private var caretHeight = 0.0;
    private var selectionRects:Array<fluxe.views.Text.TextBox> = [];

    public override function build(builder:ViewBuilder) {
        super.build(builder);

        var rrect = RRect.MakeRectXY(Rect.MakeXYWH(0, 0, this.layoutSize.width, this.layoutSize.height), 3, 3);

        var paint = new Paint();
        paint.setAntiAlias(true);
        paint.setColor(Color.RGBA(0.6, 0.6, 0.6, 0.8));
        paint.setStyle(PaintStyle.Stroke);
        builder.canvas.drawRRect(rrect, paint);

        if (this.isFocused) {
            paint.setColor(Color.RGBA(0.6, 0.8, 1.0, 0.8));
            paint.setStrokeWidth(2);
            var rrect = RRect.MakeRectXY(Rect.MakeXYWH(1, 1, this.layoutSize.width - 2, this.layoutSize.height - 2), 3, 3);
            builder.canvas.drawRRect(rrect, paint);
            paint.setStrokeWidth(1);
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
            var isSelectionReverse = this.selectionRange.start > this.selectionRange.end;

            var rangeStart = 0;
            if (hasSelection) {
                rangeStart = isSelectionReverse ? this.selectionRange.end : this.selectionRange.start;
            }
            var rangeEnd = isSelectionReverse ? this.selectionRange.start : this.selectionRange.end;

            var rects = this.text.getRectsForRange(rangeStart, rangeEnd);
            if (rects.length > 0) {
                var caretRect = rects[rects.length - 1];
                if (isSelectionReverse) {
                    caretRect = rects[0];
                }

                caretPosition = {
                    x: isSelectionReverse ? caretRect.left : caretRect.right,
                    y: caretRect.top,
                };
                caretHeight = caretRect.bottom - caretRect.top;
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
            var caretRect = Rect.MakeXYWH(this.text.layoutPosition.left + caretPosition.x, this.text.layoutPosition.top + caretPosition.y, 1, caretHeight);
            paint.setStyle(PaintStyle.Fill);
            paint.setColor(Color.RGBA(1.0, 1.0, 1.0, 1.0));
            builder.canvas.drawRect(caretRect, paint);
        }
    }

    public function didGainFocus():Void {
        this.isFocused = true;
        startCaretBlink();
    }

    public function didLoseFocus():Void {
        this.isFocused = false;
        stopCaretBlink();
    }

    private function stopCaretBlink() {
        this.isShowingCaret = false;
        this.needsRerender = true;
        if (caretTimer != null) {
            fluxe.animation.Timer.stopTimer(caretTimer);
            caretTimer = null;
        }
    }

    private function startCaretBlink() {
        stopCaretBlink();

        this.isShowingCaret = true;
        if (caretTimer == null) {
            caretTimer = fluxe.animation.Timer.startInterval(500, () -> {
                this.isShowingCaret = !this.isShowingCaret;
                this.needsRerender = true;
            });
        }
        this.needsRerender = true;
    }

    public function onPressStarted(event:PressStartedEvent) {
    }

    public function onPressFinished(event:PressFinishedEvent) {
        this.viewManager.focusManager.gainFocus(this);
    }

    public function onPressCanceled(event:PressCanceledEvent) {
    }

    public function onTextInsert(text:String):Void {
        var isSelectionReverse = this.selectionRange.start > this.selectionRange.end;
        var rangeStart = isSelectionReverse ? this.selectionRange.end : this.selectionRange.start;
        var rangeEnd = isSelectionReverse ? this.selectionRange.start : this.selectionRange.end;

        this.value = this.value.substring(0, rangeStart) + text + this.value.substring(rangeEnd);
        this.needsRerender = true;
        this.needsCaretUpdate = true;
        this.selectionRange.end = rangeStart + text.length;
        this.selectionRange.start = this.selectionRange.end;
        startCaretBlink();
    }

    public function onKeyboardMoveAction(action:KeyboardMoveInstruction):Void {
        // trace('\n\n');
        // trace('isAll ${action.isAll}');
        // trace('isDoc ${action.isDocument}');
        // trace('isPage ${action.isPage}');
        // trace('isParagraph ${action.isParagraph}');
        // trace('isLine ${action.isLine}');
        // trace('isWord ${action.isWord}');
        // trace('-');
        // trace('isLeft ${action.isLeft}');
        // trace('isRight ${action.isRight}');
        // trace('isForwards ${action.isForwards}');
        // trace('isBackwards ${action.isBackwards}');
        // trace('-');
        // trace('isSelect ${action.isSelect}');
        // trace('isDelete ${action.isDelete}');

        // trace(this.selectionRange);

        var newRangeStart = this.selectionRange.start;
        var newRangeEnd = this.selectionRange.end;
        var hadSelectionBefore = this.selectionRange.start != this.selectionRange.end;

        if (!(hadSelectionBefore && action.isDelete)) {
            if (action.isAll || action.isDocument) {
                if (action.isSelect) {
                    newRangeStart = 0;
                    newRangeEnd = this.value.length;
                } else if (action.isBackwards || action.isLeft || action.isUp) {
                    newRangeStart = 0;
                    newRangeEnd = 0;
                } else if (action.isForwards || action.isRight || action.isDown) {
                    newRangeStart = this.value.length;
                    newRangeEnd = this.value.length;
                }
            } else if (action.isPage) {
            } else if (action.isParagraph) {
            } else if (action.isLine) {
                var i = this.selectionRange.end;
                var r = NEW_LINE_REGEX;
                if (action.isLeft || action.isBackwards) {
                    i = this.selectionRange.end - 1;
                    while (i > 0) {
                        if (r.match(this.value.substr(i, 1))) {
                            break;
                        }
                        i--;
                    }
                    if (i < 0) {
                        i = 0;
                    }
                } else if (action.isRight || action.isForwards) {
                    i = this.selectionRange.end + 1;
                    while (i < this.value.length) {
                        if (r.match(this.value.substr(i, 1))) {
                            break;
                        }
                        i++;
                    }
                    if (i > this.value.length) {
                        i = this.value.length;
                    }
                }
                newRangeEnd = i;
            } else if (action.isWord) {
                var i = this.selectionRange.end;
                var foundChar = false;
                var r = ~/\w/i;
                if (action.isLeft || action.isBackwards) {
                    i = this.selectionRange.end - 1;
                    while (i > 0) {
                        if (r.match(this.value.substr(i, 1))) {
                            foundChar = true;
                        } else if (foundChar) {
                            i += 1;
                            break;
                        }
                        i--;
                    }
                    if (i < 0) {
                        i = 0;
                    }
                } else if (action.isRight || action.isForwards) {
                    i = this.selectionRange.end + 1;
                    while (i < this.value.length) {
                        if (r.match(this.value.substr(i, 1))) {
                            foundChar = true;
                        } else if (foundChar) {
                            break;
                        }
                        i++;
                    }
                    if (i > this.value.length) {
                        i = this.value.length;
                    }
                }
                newRangeEnd = i;
            } else {
                if (action.isLeft || action.isBackwards) {
                    newRangeEnd = this.selectionRange.end - 1;
                    if (newRangeEnd < 0) {
                        newRangeEnd = 0;
                    }
                } else if (action.isRight || action.isForwards) {
                    newRangeEnd = this.selectionRange.end + 1;
                    if (newRangeEnd > this.value.length) {
                        newRangeEnd = this.value.length;
                    }
                }
            }
        }

        // trace(this.selectionRange);
        if (action.isDelete) {
            var strDeleteStart = newRangeStart;
            var strDeleteEnd = newRangeEnd;
            if (strDeleteStart > strDeleteEnd) {
                var tmp = strDeleteStart;
                strDeleteStart = strDeleteEnd;
                strDeleteEnd = tmp;
            }

            var isForward = newRangeStart < newRangeEnd;

            this.value = this.value.substring(0, strDeleteStart) + this.value.substring(strDeleteEnd);

            if (isForward) {
                newRangeEnd = newRangeStart;
            } else {
                newRangeStart = newRangeEnd;
            }
        } else if (!action.isSelect) {
            newRangeStart = newRangeEnd;
        }


        this.selectionRange.start = newRangeStart;
        this.selectionRange.end = newRangeEnd;

        if (this.selectionRange.start < 0) {
            this.selectionRange.start = 0;
        }
        if (this.selectionRange.start > this.value.length) {
            this.selectionRange.start = this.value.length;
        }
        if (this.selectionRange.end < 0) {
            this.selectionRange.end = 0;
        }
        if (this.selectionRange.end > this.value.length) {
            this.selectionRange.end = this.value.length;
        }

        // trace(this.selectionRange);

        this.needsRerender = true;
        this.needsCaretUpdate = true;
        startCaretBlink();
    }
}