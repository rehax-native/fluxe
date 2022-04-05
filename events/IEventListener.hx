package events;

// interface IEventListener<Event> {
// 	public function onEvent(event:Event):Void;
// }

interface IEventListener {
	// public function onEvent(event:Event):Void;
}

interface IEventListenerContainer {
    private var eventListeners:Array<IEventListener>;
}

// class EventEmitter<Event> {
// 	private var listeners:Array<EventListener<Event>> = [];

// 	public function addListener(listener:EventListener<Event>):Void {
// 		listeners.push(listener);
// 	}

// 	public function removeListener(listener:EventListener<Event>):Void {
// 		listeners.remove(listener);
// 	}

// 	public function emitEvent(event:Event):Void {
// 		for (listener in listeners) {
// 			listener.onEvent(event);
// 		}
// 	}
// }