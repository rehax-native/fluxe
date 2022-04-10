package fluxe.events;

using fluxe.views.View;

typedef MouseUpEvent = {
    public var left:Float;
    public var top:Float;
    public var button:Int;
}

typedef MouseDownEvent = {
    public var left:Float;
    public var top:Float;
    public var button:Int;
}

typedef MouseMoveEvent = {
    public var left:Float;
    public var top:Float;
}

typedef MouseEnterEvent = {
    public var left:Float;
    public var top:Float;
}

typedef MouseExitEvent = {
    public var left:Float;
    public var top:Float;
}

interface IMouseEventListener {
}

interface IMouseEventListenerContainer {
    public var mouseEventListeners:Array<IMouseEventListener>;
}


interface IMouseDownEventListener extends IMouseEventListener {
    public function onMouseDown(event:MouseDownEvent):Void;
}
interface IMouseUpEventListener extends IMouseEventListener {
    public function onMouseUp(event:MouseUpEvent):Void;
}
interface IMouseMoveEventListener extends IMouseEventListener {
    public function onMouseMove(event:MouseMoveEvent):Void;
}
interface IMouseEnterExitEventListener extends IMouseEventListener {
    public function onMouseEnter(event:MouseEnterEvent):Void;
    public function onMouseExit(event:MouseExitEvent):Void;
}

class MouseEventsManager {
    var rootView:View;

    public function new(rootView:View) {
        this.rootView = rootView;
    }

    public function handleMouseDown(event:MouseDownEvent) {
        var hitView = findViewAtPosition(event.left, event.top, rootView);
        while (hitView != null) {
            if (Std.isOfType(hitView, IMouseEventListenerContainer)) {
                var eventView = cast(hitView, IMouseEventListenerContainer);
                for (listener in eventView.mouseEventListeners) {
                    if (Std.isOfType(listener, IMouseDownEventListener)) {
                        cast(listener, IMouseDownEventListener).onMouseDown(event);
                    }
                }
            }
            if (Std.isOfType(hitView, IMouseDownEventListener)) {
                cast(hitView, IMouseDownEventListener).onMouseDown(event);
            }
            hitView = hitView.parent;
        }
    }

    public function handleMouseUp(event:MouseUpEvent) {
        var hitView = findViewAtPosition(event.left, event.top, rootView);
        while (hitView != null) {
            if (Std.isOfType(hitView, IMouseEventListenerContainer)) {
                var eventView = cast(hitView, IMouseEventListenerContainer);
                for (listener in eventView.mouseEventListeners) {
                    if (Std.isOfType(listener, IMouseUpEventListener)) {
                        cast(listener, IMouseUpEventListener).onMouseUp(event);
                    }
                }
            }
            if (Std.isOfType(hitView, IMouseUpEventListener)) {
                cast(hitView, IMouseUpEventListener).onMouseUp(event);
            }
            hitView = hitView.parent;
        }
    }

    private var previousMouseMoveListeners:Map<IMouseEnterExitEventListener, Bool> = [];

    public function handleMouseMove(event:MouseMoveEvent) {
        var hitView = findViewAtPosition(event.left, event.top, rootView);
        var newListeners:Map<IMouseEnterExitEventListener, Bool> = [];
        while (hitView != null) {
            if (Std.isOfType(hitView, IMouseEventListenerContainer)) {
                var eventView = cast(hitView, IMouseEventListenerContainer);
                for (listener in eventView.mouseEventListeners) {
                    if (Std.isOfType(listener, IMouseEnterExitEventListener)) {
                        var enterListener = cast(listener, IMouseEnterExitEventListener);
                        if (!previousMouseMoveListeners.exists(enterListener)) {
                            previousMouseMoveListeners[enterListener] = true;
                            enterListener.onMouseEnter(event);
                        }
                        newListeners[enterListener] = true;
                    }
                    if (Std.isOfType(listener, IMouseMoveEventListener)) {
                        var moveListener = cast(listener, IMouseMoveEventListener);
                        moveListener.onMouseMove(event);
                    }
                }
            }
            if (Std.isOfType(hitView, IMouseEnterExitEventListener)) {
                var enterListener = cast(hitView, IMouseEnterExitEventListener);
                if (!previousMouseMoveListeners.exists(enterListener)) {
                    previousMouseMoveListeners[enterListener] = true;
                    enterListener.onMouseEnter(event);
                }
                newListeners[enterListener] = true;
            }
            if (Std.isOfType(hitView, IMouseMoveEventListener)) {
                var moveListener = cast(hitView, IMouseMoveEventListener);
                moveListener.onMouseMove(event);
            }
            hitView = hitView.parent;
        }

        for (listener in previousMouseMoveListeners.keys()) {
            if (Std.isOfType(listener, IMouseEnterExitEventListener)) {
                var exitListener = cast(listener, IMouseEnterExitEventListener);
                if (!newListeners.exists(exitListener)) {
                    exitListener.onMouseExit(event);
                    previousMouseMoveListeners.remove(exitListener);
                }
            }
        }
    }

    private function findViewAtPosition(x:Float, y:Float, view:View):Null<View> {
		if (x >= view.layoutPosition.left && x <= view.layoutPosition.left + view.layoutSize.width) {
		    if (y >= view.layoutPosition.top && y <= view.layoutPosition.top + view.layoutSize.height) {
                var subViews = view.subViews;
                for (item in subViews) {
                    var hitView = findViewAtPosition(x, y, item);
                    if (hitView != null) {
                        return hitView;
                    }
                }
                return view;
            }
        }
        return null;
    }
}
