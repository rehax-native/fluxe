package fluxe.views;

using fluxe.render_pipeline.RenderPipeline;
using fluxe.events.MouseEventsManager;
using fluxe.events.KeyEventsManager;
using fluxe.events.ActionEventsManager;
using fluxe.events.FocusManager;
using fluxe.views.Externs;

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

    public function renderCallback(width:Int, height:Int, scale:Float):NativeSurface {
        var surface = pipeline.render(width, height, scale);
        return surface._surface;
    }

    public function mouseCallback(instruction:MouseInstruction):Void {
        mouseManager.handleInstruction(instruction);
    }

    public function keyCallback(instruction:KeyboardKeyInstruction):Void {
        // if (instruction.isDown) {
        //     _keyManager.onKeyDown(CHAR(str));
        // }
    }

    public function textCallback(str:String):Void {
        _actionManager.onTextInsert(str);
    }

    public function moveCallback(instruction:KeyboardMoveInstruction):Void {
        _actionManager.onKeyboardMoveAction(instruction);
    }
}