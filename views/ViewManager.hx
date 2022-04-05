package views;

using render_pipeline.RenderPipeline;
using events.MouseEventsManager;
using events.KeyEventsManager;
using events.ActionEventsManager;
using events.FocusManager;
using views.Externs;

class ViewsContainer extends View {
    var _viewManager:ViewManager;

    public function new(viewManager:ViewManager) {
        super();
        this.layoutPosition = { left: 0, top: 0 };
        this._viewManager = viewManager;
    }

    public override function get_viewManager():ViewManager {
        return _viewManager;
    }

    public override function set_needsRerender(rerender:Bool):Bool {
        if (rerender) {
            this._viewManager.setNeedsRerender();
        }
        return rerender;
    }
}

class ViewManager {
    var pipeline:RenderPipeline;
    var mouseManager:MouseEventsManager;
    var _focusManager:FocusManager;
    var _keyManager:KeyEventsManager;
    var _actionManager:ActionEventsManager;
    var container:ViewsContainer;

    public function new(view:View) {
        container = new ViewsContainer(this);
        pipeline = new RenderPipeline(container);
        mouseManager = new MouseEventsManager(container);
        _focusManager = new FocusManager();
        _keyManager = new KeyEventsManager();
        _keyManager.focusManager = _focusManager;
        _actionManager = new ActionEventsManager();
        _actionManager.focusManager = _focusManager;

        container.addSubView(view);
    }

    public function setNeedsRerender() {
        onNeedsRerender();
    }

    public var onNeedsRerender = () -> {};

    public var mouseEventsManager(get, null):MouseEventsManager;
    public function get_mouseEventsManager():MouseEventsManager {
        return mouseManager;
    }

    public var focusManager(get, null):FocusManager;
    public function get_focusManager():FocusManager {
        return _focusManager;
    }

    public function renderCallback(width:Int, height:Int):NativeSurface {
        var surface = pipeline.render(width, height);
        return surface._surface;
    }

    public function mouseDownCallback(left:Float, top:Float, buttonIndex:Int):Void {
        mouseManager.handleMouseDown({
            left: left,
            top: top,
            button: buttonIndex,
        });
    }

    public function mouseUpCallback(left:Float, top:Float, buttonIndex:Int):Void {
        mouseManager.handleMouseUp({
            left: left,
            top: top,
            button: buttonIndex,
        });
    }

    public function mouseMoveCallback(left:Float, top:Float):Void {
        mouseManager.handleMouseMove({
            left: left,
            top: top,
        });
    }

    public function keyDownCallback(code:Int):Void {
        // _keyManager.onKeyDown(CHAR("A"));
    }

    public function keyUpCallback(code:Int):Void {
        // _keyManager.onKeyUp(ley);
    }

    public function textCallback(str:String):Void {
        _keyManager.onKeyDown(CHAR(str));
        _actionManager.onAction(INSERT_STRING(str));
    }

    public function moveLeftCallback(select:Bool):Void {
        _actionManager.onAction(select ? LEFT_AND_SELECT : LEFT);
        // _keyManager.onKeyDown(CHAR(str));
    }

    public function moveRightCallback(select:Bool):Void {
        _actionManager.onAction(select ? RIGHT_AND_SELECT : RIGHT);
        // _keyManager.onKeyDown(CHAR(str));
    }

    public function moveWordLeftCallback(select:Bool):Void {
        _actionManager.onAction(select ? WORD_LEFT_AND_SELECT : WORD_LEFT);
        // _keyManager.onKeyDown(CHAR(str));
    }

    public function moveWordRightCallback(select:Bool):Void {
        _actionManager.onAction(select ? WORD_RIGHT_AND_SELECT : WORD_RIGHT);
        // _keyManager.onKeyDown(CHAR(str));
    }

    public function moveBackwardCallback(select:Bool):Void {
        _actionManager.onAction(BACKWARD); // todo handle select
        // _keyManager.onKeyDown(CHAR(str));
    }

    public function moveForwardCallback(select:Bool):Void {
        _actionManager.onAction(FORWARD); // todo handle select
        // _keyManager.onKeyDown(CHAR(str));
    }

    public function deleteBackwardCallback():Void {
        _actionManager.onAction(DELETE_BACKWARD);
        // _keyManager.onKeyDown(CHAR(str));
    }

    public function deleteForwardCallback():Void {
        _actionManager.onAction(DELETE_FORWARD);
        // _keyManager.onKeyDown(CHAR(str));
    }

    public function selectAllCallback():Void {
        _actionManager.onAction(SELECT_ALL);
        // _keyManager.onKeyDown(CHAR(str));
    }
}