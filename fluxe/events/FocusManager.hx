package fluxe.events;

using fluxe.views.View;

interface IFocusable {
    public function didGainFocus():Void;
    public function didLoseFocus():Void;
}

class FocusManager {
    public function new() {}

    private var currentFocusable:Null<IFocusable> = null;
    private var focusables:Array<IFocusable> = [];

    public function prepareForCollectingFocusables() {
    }

    public function collectFocusable(view:IFocusable) {
        focusables.push(view);
    }

    public function collectFocusables(containerView:View) {
        focusables = [];
        collectFocusablesTraverse(containerView);
    }

    public function collectFocusablesTraverse(view:View) {
        var subViews = view.subViews;
        for (subView in subViews) {
            if (Std.isOfType(subView, IFocusable)) {
                focusables.push(cast subView);
            }
            collectFocusablesTraverse(subView);
        }
    }

    public function focusNext():Void {
        var prev = currentFocusable;
        if (focusables.length > 0) {
            if (currentFocusable == null) {
                currentFocusable = focusables[0];
            } else {
                var index = focusables.indexOf(currentFocusable);
                index = (index + 1) % focusables.length;
                if (index < focusables.length) {
                    currentFocusable = focusables[index];
                } else {
                    currentFocusable = null;
                }
            }
        } else {
            currentFocusable = null;
        }

        if (prev != null) {
            prev.didLoseFocus();
        }
        if (currentFocusable != null) {
            currentFocusable.didGainFocus();
        }
    }

    public function focusPrevious():Void {
        var prev = currentFocusable;
        if (focusables.length > 0) {
            if (currentFocusable == null) {
                currentFocusable = focusables[0];
            } else {
                var index = focusables.indexOf(currentFocusable) - 1;
                if (index < 0) {
                    index = focusables.length - 1;
                }
                if (index < focusables.length) {
                    currentFocusable = focusables[index];
                } else {
                    currentFocusable = null;
                }
            }
        } else {
            currentFocusable = null;
        }

        if (prev != null) {
            prev.didLoseFocus();
        }
        if (currentFocusable != null) {
            currentFocusable.didGainFocus();
        }
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