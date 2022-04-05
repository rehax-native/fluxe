package events;

using views.View;

interface IFocusable {
    public function didGainFocus():Void;
    public function didLoseFocus():Void;
}

class FocusManager {
    public function new() {}

    private var currentFocusable:Null<IFocusable> = null;
    private var focusables:Array<IFocusable>;

    public function registerFocusable(focusable:IFocusable):Void {
        focusables.push(focusable);
    }

    public function unregisterFocusable(focusable:IFocusable):Void {
        focusables.remove(focusable);
    }

    public function focusNext(view:View):Void {
        // if (currentFocusable == null) {
        //     currentFocusable = focusables[0];
        // } else {
        //     var index = focusables.indexOf(currentFocusable);
        //     if (index == focusables.length - 1) {
        //         currentFocusable = focusables[0];
        //     } else {
        //         currentFocusable = focusables[index + 1];
        //     }
        // }
        // gainFocus(nextFocusable);
    }

    private function findNextFocusable(view:View) {
        // view.
    }

    public function loseFocus() {
        if (currentFocusable != null) {
            currentFocusable.didLoseFocus();
            currentFocusable = null;
        }
    }

    public function gainFocus(focusable:IFocusable):Void {
        loseFocus();
        currentFocusable = focusable;
        currentFocusable.didGainFocus();
    }

    public function getCurrentFocusable():IFocusable {
        return currentFocusable;
    }
}