package fluxe.views;

using fluxe.views.Externs;

typedef Window = cpp.RawPointer<Void>;

@:include("engine.h")
@:native("fluxe::Engine")
extern class Engine {
    @:native("new fluxe::Engine")
    public static function Create():cpp.Pointer<Engine>;

    extern public function createPlatformWindow():Window;
    extern public function attachToPlatformWindow(window:Window):Void;
    extern public function attachToPlatformView(view: cpp.RawPointer<Void>):Void;
    extern public function setRenderCallback(callback:(width:Int, height:Int) -> NativeSurface):Void;
    extern public function startMainLoop():Void;
    extern public function detachFromPlatformWindow():Void;
    extern public function detachFromPlatformView():Void;
    extern public function closePlatformWindow(window:Window):Void;

    extern public function setNeedsRerender():Void;

    extern public function setMouseDownCallback(callback:(left:Float, top:Float, button:Int) -> Void):Void;
    extern public function setMouseUpCallback(callback:(left:Float, top:Float, button:Int) -> Void):Void;
    extern public function setMouseMoveCallback(callback:(left:Float, top:Float, button:Int) -> Void):Void;
}

@:unreflective
@:header("shell/")
class EngineUtility {
    public static function startWithView(view:View):Void {
        var util = new EngineUtility();
        var window = util.engine.ptr.createPlatformWindow();
        util.initWithWindow(view, window);
        trace(util);
    }

    public static function startWithViewAndPlatformView(view:View, platformView:cpp.RawPointer<Void>):Void {
        var util = new EngineUtility();
        util.initWithPlatformView(view, platformView);
        trace(util);
    }

    var engine = Engine.Create();
    var viewManager:ViewManager;
    private function new() {}

    private function initWithWindow(view:View, window:cpp.RawPointer<Void>) {
        engine.ptr.attachToPlatformWindow(window);
        viewManager = new ViewManager(view);
        viewManager.onNeedsRerender = () -> {
            engine.ptr.setNeedsRerender();
        };
        untyped __cpp__ ("this->engine->ptr->setRenderCallback([this] (int w, int h, float scale) { HX_TOP_OF_STACK return viewManager->renderCallback(w, h, scale); })");
        untyped __cpp__ ("this->engine->ptr->setMouseCallback([this] (ShellMouseInstruction instruction) { HX_TOP_OF_STACK return handleMouseCallback(instruction); })");
        untyped __cpp__ ("this->engine->ptr->setKeyCallback([this] (ShellKeyboardKeyInstruction instruction) { HX_TOP_OF_STACK return handleKeyCallback(instruction); })");
        untyped __cpp__ ("this->engine->ptr->setMoveCallback([this] (ShellKeyboardMoveInstruction instruction) { HX_TOP_OF_STACK return handleMoveCallback(instruction); })");
        untyped __cpp__ ("this->engine->ptr->setTextCallback([this] (const char * str) { HX_TOP_OF_STACK return viewManager->textCallback(String(str)); })");
        untyped __cpp__ ("::hx::SetTopOfStack((int *)0,true);");
        engine.ptr.startMainLoop();
        engine.ptr.detachFromPlatformWindow();
        engine.ptr.closePlatformWindow(window);
        engine.destroy();
    }

    private function initWithPlatformView(view:View, platformView:cpp.RawPointer<Void>) {
        engine.ptr.attachToPlatformView(platformView);
        viewManager = new ViewManager(view);
        viewManager.onNeedsRerender = () -> {
            engine.ptr.setNeedsRerender();
        };
        untyped __cpp__ ("this->engine->ptr->setRenderCallback([this] (int w, int h, float scale) { HX_TOP_OF_STACK return viewManager->renderCallback(w, h, scale); })");
        untyped __cpp__ ("this->engine->ptr->setMouseCallback([this] (ShellMouseInstruction instruction) { HX_TOP_OF_STACK return handleMouseCallback(instruction); })");
        untyped __cpp__ ("this->engine->ptr->setKeyCallback([this] (ShellKeyboardKeyInstruction instruction) { HX_TOP_OF_STACK return handleKeyCallback(instruction); })");
        untyped __cpp__ ("this->engine->ptr->setMoveCallback([this] (ShellKeyboardMoveInstruction instruction) { HX_TOP_OF_STACK return handleMoveCallback(instruction); })");
        untyped __cpp__ ("this->engine->ptr->setTextCallback([this] (const char * str) { HX_TOP_OF_STACK return viewManager->textCallback(String(str)); })");
        // untyped __cpp__ ("::hx::SetTopOfStack((int *)0,true);");
        // engine.ptr.detachFromPlatformView();
        // engine.destroy();
    }

    public function handleMouseCallback(instruction:fluxe.views.Externs.NativeMouseInstruction) {
        viewManager.mouseCallback(MouseInstruction.FromNative(instruction));
    }

    public function handleKeyCallback(instruction:fluxe.views.Externs.NativeKeyboardKeyInstruction) {
        viewManager.keyCallback(KeyboardKeyInstruction.FromNative(instruction));
    }

    public function handleMoveCallback(instruction:fluxe.views.Externs.NativeKeyboardMoveInstruction) {
        viewManager.moveCallback(KeyboardMoveInstruction.FromNative(instruction));
    }
}