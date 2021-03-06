package fluxe.events;

enum Key {
    UP;
    DOWN;
    LEFT;
    RIGHT;
    SPACE;
    ENTER;
    ESCAPE;
    BACKSPACE;
    TAB;
    SHIFT;
    CTRL;
    ALT;
    ALT_GR;
    CAPS_LOCK;
    NUM_LOCK;
    SCROLL_LOCK;
    F1;
    F2;
    F3;
    F4;
    F5;
    F6;
    F7;
    F8;
    F9;
    F10;
    F11;
    F12;
    F13;
    F14;
    F15;
    F16;
    F17;
    F18;
    F19;
    F20;
    F21;
    F22;
    F23;
    F24;
    PRINT_SCREEN;
    INSERT;
    DELETE;
    HOME;
    END;
    PAGE_UP;
    PAGE_DOWN;
    LEFT_ARROW;
    RIGHT_ARROW;
    UP_ARROW;
    DOWN_ARROW;
    NUM_0;
    NUM_1;
    NUM_2;
    NUM_3;
    NUM_4;
    NUM_5;
    NUM_6;
    NUM_7;
    NUM_8;
    NUM_9;
    NUM_MULTIPLY;
    NUM_ADD;
    NUM_SUBTRACT;
    NUM_DECIMAL;
    NUM_DIVIDE;
    NUM_LOCK_CLEAR;
    NUM_ENTER;
    NUM_EQUAL;
    NUM_COMMA;
    NUM_PERIOD;
    NUM_MINUS;
    NUM_PLUS;
    NUM_SLASH;
    NUM_ASTERISK;
    NUM_BACK_SLASH;
    NUM_COLON;
    NUM_SEMICOLON;
    NUM_LESS_THAN;
    NUM_GREATER_THAN;
    NUM_QUESTION_MARK;
    NUM_AT;
    CHAR(char:String);
}

interface IKeyListener {
    public function onKeyDown(key:Key):Void;
    public function onKeyUp(key:Key):Void;
}

class KeyEventsManager {
    public function new() {}

    public var focusManager:FocusManager;

    public function onKeyDown(key:Key):Void {
        var currentFocusable = focusManager.getCurrentFocusable();
        if (Std.isOfType(currentFocusable, IKeyListener)) {
            var listener = cast(currentFocusable, IKeyListener);
            listener.onKeyDown(key);
        }
    }

    public function onKeyUp(key:Key):Void {
        var currentFocusable = focusManager.getCurrentFocusable();
        if (Std.isOfType(currentFocusable, IKeyListener)) {
            var listener = cast(currentFocusable, IKeyListener);
            listener.onKeyUp(key);
        }
    }
}