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
    extern public function setRenderCallback(callback:(width:Int, height:Int) -> NativeSurface):Void;
    extern public function startMainLoop():Void;
    extern public function detachFromPlatformWindow():Void;
    extern public function closePlatformWindow(window:Window):Void;

    extern public function setNeedsRerender():Void;

    extern public function setMouseDownCallback(callback:(left:Float, top:Float, button:Int) -> Void):Void;
    extern public function setMouseUpCallback(callback:(left:Float, top:Float, button:Int) -> Void):Void;
    extern public function setMouseMoveCallback(callback:(left:Float, top:Float, button:Int) -> Void):Void;
}

@:unreflective
class EngineUtility {
    public static function startWithView(view:View):Void {
        var util = new EngineUtility(view);
        trace(util);
    }


    var engine = Engine.Create();
    var viewManager:ViewManager;

    private function new(view:View) {
        var window = engine.ptr.createPlatformWindow();
        engine.ptr.attachToPlatformWindow(window);
        viewManager = new ViewManager(view);
        viewManager.onNeedsRerender = () -> {
            engine.ptr.setNeedsRerender();
        };
        untyped __cpp__ ("this->engine->ptr->setRenderCallback([this] (int w, int h) { return viewManager->renderCallback(w, h); })");
        untyped __cpp__ ("this->engine->ptr->setMouseDownCallback([this] (float l, float t, int n) { return viewManager->mouseDownCallback(l, t, n); })");
        untyped __cpp__ ("this->engine->ptr->setMouseMoveCallback([this] (float l, float t) { return viewManager->mouseMoveCallback(l, t); })");
        untyped __cpp__ ("this->engine->ptr->setMouseUpCallback([this] (float l, float t, int n) { return viewManager->mouseUpCallback(l, t, n); })");
        untyped __cpp__ ("this->engine->ptr->setKeyDownCallback([this] (int code) { return viewManager->keyDownCallback(code); })");
        untyped __cpp__ ("this->engine->ptr->setKeyUpCallback([this] (int code) { return viewManager->keyUpCallback(code); })");
        untyped __cpp__ ("this->engine->ptr->setTextCallback([this] (const char * str) { return viewManager->textCallback(String(str)); })");

        untyped __cpp__ ("this->engine->ptr->setMoveLeftCallback([this] (bool select) { return viewManager->moveLeftCallback(select); })");
        untyped __cpp__ ("this->engine->ptr->setMoveRightCallback([this] (bool select) { return viewManager->moveRightCallback(select); })");
        untyped __cpp__ ("this->engine->ptr->setMoveWordLeftCallback([this] (bool select) { return viewManager->moveWordLeftCallback(select); })");
        untyped __cpp__ ("this->engine->ptr->setMoveWordRightCallback([this] (bool select) { return viewManager->moveWordRightCallback(select); })");
        untyped __cpp__ ("this->engine->ptr->setMoveBackwardCallback([this] (bool select) { return viewManager->moveBackwardCallback(select); })");
        untyped __cpp__ ("this->engine->ptr->setMoveForwardCallback([this] (bool select) { return viewManager->moveForwardCallback(select); })");
        untyped __cpp__ ("this->engine->ptr->setDeleteBackwardCallback([this] () { return viewManager->deleteBackwardCallback(); })");
        untyped __cpp__ ("this->engine->ptr->setDeleteForwardCallback([this] () { return viewManager->deleteForwardCallback(); })");
        untyped __cpp__ ("this->engine->ptr->setSelectAllCallback([this] () { return viewManager->selectAllCallback(); })");
        engine.ptr.startMainLoop();
        engine.ptr.detachFromPlatformWindow();
        engine.ptr.closePlatformWindow(window);
        engine.destroy();
    }
}