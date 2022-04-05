package events;

using views.View;

class MouseUpEvent {
    public function new () {}
    public var left:Float;
    public var top:Float;
    public var button:Int;
}

class MouseDownEvent {
    public function new () {}
    public var left:Float;
    public var top:Float;
    public var button:Int;
}

class MouseMoveEvent {
    public function new () {}
    public var left:Float;
    public var top:Float;
}

interface IMouseDownListener {
    public function onMouseDown(event:MouseDownEvent):Void;
}
interface IMouseUpListener {
    public function onMouseUp(event:MouseUpEvent):Void;
}
interface IMouseMoveListener {
    public function onMouseMove(event:MouseMoveEvent):Void;
}

class MouseEventsManager {
    var rootView:View;

    public function new(rootView:View) {
        this.rootView = rootView;
    }

    // private var mouseUpListeners:Array<IMouseUpListener> = [];
    // private var mouseDownListeners:Array<IMouseDownListener> = [];
    // private var mouseMoveListeners:Array<IMouseMoveListener> = [];

    // public function addMouseUpListener(view:IMouseUpListener) {
    //     mouseUpListeners.push(view);
    // }

    // public function addMouseDownListener(view:IMouseDownListener) {
    //     mouseDownListeners.push(view);
    // }

    // public function addMouseMoveListener(view:IMouseMoveListener) {
    //     mouseMoveListeners.push(view);
    // }

	// public function removeMouseUpListener(view:IMouseUpListener):Void {
	// 	mouseUpListeners.remove(view);
	// }

	// public function removeMouseDownListener(view:IMouseDownListener):Void {
	// 	mouseDownListeners.remove(view);
	// }

	// public function removeMouseMoveListener(view:IMouseMoveListener):Void {
	// 	mouseMoveListeners.remove(view);
	// }

    public function handleMouseDown(event:MouseDownEvent) {
        var hitView = findViewAtPosition(event.left, event.top, rootView);
        while (hitView != null) {
            if (Std.isOfType(hitView, IMouseDownListener)) {
                var listener = cast(hitView, IMouseDownListener);
                listener.onMouseDown(event);
            }
            hitView = hitView.parent;
        }
    }

    public function handleMouseUp(event:MouseUpEvent) {
        var hitView = findViewAtPosition(event.left, event.top, rootView);
        while (hitView != null) {
            if (Std.isOfType(hitView, IMouseUpListener)) {
                var listener = cast(hitView, IMouseUpListener);
                listener.onMouseUp(event);
            }
            hitView = hitView.parent;
        }
    }

    public function handleMouseMove(event:MouseMoveEvent) {
        var hitView = findViewAtPosition(event.left, event.top, rootView);
        while (hitView != null) {
            if (Std.isOfType(hitView, IMouseMoveListener)) {
                var listener = cast(hitView, IMouseMoveListener);
                listener.onMouseMove(event);
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
