package fluxe.events;

interface IActionListener {
    public function onTextInsert(text:String):Void;
    public function onKeyboardMoveAction(action:fluxe.views.Externs.KeyboardMoveInstruction):Void;
}

class ActionEventsManager {
    public function new() {}

    public var focusManager:FocusManager;

    public function onKeyboardMoveAction(action:fluxe.views.Externs.KeyboardMoveInstruction):Void {
        var currentFocusable = focusManager.getCurrentFocusable();
        if (Std.isOfType(currentFocusable, IActionListener)) {
            var listener = cast(currentFocusable, IActionListener);
            listener.onKeyboardMoveAction(action);
        }
    }

    public function onTextInsert(text:String):Void {
        var currentFocusable = focusManager.getCurrentFocusable();
        if (Std.isOfType(currentFocusable, IActionListener)) {
            var listener = cast(currentFocusable, IActionListener);
            listener.onTextInsert(text);
        }
    }
}