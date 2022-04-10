package fluxe.events;

using fluxe.views.View;
using fluxe.events.MouseEventsManager;

typedef PressStartedEvent = {}

typedef PressFinishedEvent = {}

typedef PressCanceledEvent = {}

interface IPressEventListener {
    public function onPressStarted(event:PressStartedEvent):Void;
    public function onPressFinished(event:PressFinishedEvent):Void;
    public function onPressCanceled(event:PressCanceledEvent):Void;
}

class PressDetector implements IMouseDownEventListener implements IMouseUpEventListener implements IMouseEnterExitEventListener {

    private var eventListener:IPressEventListener;
    private var isPressing = false;

    public function new(eventListener:IPressEventListener) {
        this.eventListener = eventListener;
    }

    public function onMouseDown(event:MouseDownEvent):Void {
        isPressing = true;
        this.eventListener.onPressStarted({});
    }

    public function onMouseUp(event:MouseUpEvent):Void {
        if (isPressing) {
            isPressing = false;
            this.eventListener.onPressFinished({});
        }
    }

    public function onMouseEnter(event:MouseEnterEvent):Void {
    }

    public function onMouseExit(event:MouseExitEvent):Void {
        if (isPressing) {
            isPressing = false;
            this.eventListener.onPressCanceled({});
        }
    }
}