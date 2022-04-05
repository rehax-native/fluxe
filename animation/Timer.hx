package animation;

@:include("shell/timer.h")
@:structAccess
@:native("fluxe::Timer")
extern class NativeTimer {
    public static function startInterval(intervalMs:Int, tick:() -> Void):cpp.Pointer<NativeTimer>;
    public static function stopTimer(timer:cpp.Pointer<NativeTimer>):Void;
    // public static function isRunning(timer:cpp.Pointer<NativeTimer>):Bool;
}

class Timer {
    var _timer:cpp.Pointer<NativeTimer>;

    private function new () {}

    public static function startInterval(intervalMs:Int, tick:() -> Void):Timer {
        var timer = new Timer();
        timer._timer = NativeTimer.startInterval(intervalMs, tick);
        return timer;
    }

    public static function stopTimer(timer:Timer):Void {
        NativeTimer.stopTimer(timer._timer);
    }

    // public static function isRunning(timer:Timer):Bool {
    //     return NativeTimer.isRunning(timer._timer);
    // }
}