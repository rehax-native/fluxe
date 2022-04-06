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
interface IMouseEnterEventListener extends IMouseEventListener {
    public function onMouseEnter(event:MouseEnterEvent):Void;
}
interface IMouseExitEventListener extends IMouseEventListener {
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

    public function handleMouseMove(event:MouseMoveEvent) {
        var hitView = findViewAtPosition(event.left, event.top, rootView);
        while (hitView != null) {
            if (Std.isOfType(hitView, IMouseEventListenerContainer)) {
                var eventView = cast(hitView, IMouseEventListenerContainer);
                for (listener in eventView.mouseEventListeners) {
                    if (Std.isOfType(listener, IMouseMoveEventListener)) {
                        cast(listener, IMouseMoveEventListener).onMouseMove(event);
                    }
                }
            }
            if (Std.isOfType(hitView, IMouseMoveEventListener)) {
                cast(hitView, IMouseMoveEventListener).onMouseMove(event);
            }
            hitView = hitView.parent;
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
