
class PressEvent {
}

class PressDetector {
    private _pressEvents: PressEvent[] = [];
    private _pressing: boolean = false;
    private _pressTimer: number = 0;
    private _pressStart: number = 0;
    private _pressEnd: number = 0;
    private _pressDuration: number = 0;
    private _pressCount: number = 0;
    private _pressingTimeout: number = 0;
    private _pressingInterval: number = 0;
    private _pressingTimeoutCallback: () => void = null;
    private _pressingIntervalCallback: () => void = null;
    
    constructor(private _element: HTMLElement, private _pressDurationThreshold: number = 500) {
        this._element.addEventListener('touchstart', this._onTouchStart.bind(this));
        this._element.addEventListener('touchend', this._onTouchEnd.bind(this));
        this._element.addEventListener('touchcancel', this._onTouchCancel.bind(this));
    }
    
    private _onTouchStart(event: TouchEvent) {
        if (this._pressing) {
        return;
        }
    
        this._pressing = true;
        this._pressStart = Date.now();
        this._pressCount = 0;
        this._pressTimer = setTimeout(() => {
        this._pressingTimeoutCallback = () => {
            this._pressEvents.push(new PressEvent());
            this._pressingTimeoutCallback = null;
        };
        this._pressingTimeoutCallback();
        }, this._pressDurationThreshold);
    }
    
    private _onTouchEnd(event: TouchEvent) {
        if (!this._pressing) {
        return;
        }
    
        this._pressing = false;
        this._pressEnd = Date.now();
        this._pressDuration = this._pressEnd - this._pressStart;
        this._pressCount++;
        clearTimeout(this._pressTimer);
        if (this._pressingTimeoutCallback) {
        clearTimeout(this._pressingTimeoutCallback);
        this._pressingTimeoutCallback = null;
        }
        if (this._pressing
}