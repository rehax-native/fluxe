package fluxe.views;

using fluxe.layout.ILayout;
using fluxe.layout.ILayoutObject;
using fluxe.layout.LayoutConstraint;
using fluxe.layout.LayoutTypes;
using fluxe.layout.StackLayout;

using fluxe.render_pipeline.RenderStrategy;

class View implements ILayoutObject implements fluxe.events.MouseEventsManager.IMouseEventListenerContainer {
    public static var defaultRenderStrategy:RenderStrategy = new PaintAlwaysRenderStrategy();
    public function renderStrategy():RenderStrategy {
        return defaultRenderStrategy;
    }

    public function new() {}

    var viewManager(get, null):ViewManager;

    public function get_viewManager():ViewManager {
        return _parent.get_viewManager();
    }

    public var needsRerender(default, set):Bool;
    public function set_needsRerender(rerender:Bool):Bool {
        this.needsRerender = rerender;
        if (rerender && _parent != null) {
            _parent.set_needsRerender(rerender);
        }
        return rerender;
    }

    var _subViews:Array<View> = [];
    public var subViews(get, null):Array<View>;

    var _parent:Null<View> = null;
    public var parent(get, null):Null<View>;

    public function get_subViews():Array<View> {
        return [for (i in _subViews) i];
    }

    public function get_parent():Null<View> {
        return _parent;
    }

    public function addSubView(view:View) {
        _subViews.push(view);
        view._parent = this;
        view.onAddedToParent(this);
    }

    public function removeSubView(view:View) {
        _subViews.remove(view);
        view._parent = null;
        view.onRemovedFromParent(this);
    }

    public function onAddedToParent(parent:View) {}
    public function onRemovedFromParent(parent:View) {}
    // public function onMounted() {}
    // public function onUnMounted() {}

    public var layout(default, set):Null<ILayout> = null;
    public var layoutSize:Null<LayoutSize>;
    public var layoutPosition:Null<LayoutPosition>;
    public var layoutSizeOverride:Null<LayoutSizeOverride>;
    public var layoutPositionOverride:Null<LayoutPositionOverride>;

    public var size(get, set):Null<LayoutSizeOverride>;
    public var position(get, set):Null<LayoutPositionOverride>;

    public function set_size(size:Null<LayoutSizeOverride>):Null<LayoutSizeOverride> {
        this.layoutSizeOverride = size;
        return size;
    }

    public function set_position(position:Null<LayoutPositionOverride>):Null<LayoutPositionOverride> {
        this.layoutPositionOverride = position;
        return position;
    }

    public function get_size():Null<LayoutSizeOverride> {
        return this.layoutSizeOverride;
    }

    public function get_position():Null<LayoutPositionOverride> {
        return this.layoutPositionOverride;
    }

    public function set_layout(layout:Null<ILayout>):Null<ILayout> {
        this.layout = layout;
        this.needsRerender = true; // TODO this should be `needsLayout`, but that's currently not implemented yet
        return layout;
    }

    public var mouseEventListeners:Array<fluxe.events.MouseEventsManager.IMouseEventListener> = [];

    public function measureLayout(constraints:LayoutConstraint, parentSize:PossibleLayoutSize):Void {
        var layout = this.layout;
        if (layout == null) {
            layout = new StackLayout();
        }
        // var subLayoutObjects = cast(this.subViews, Array<Dynamic>);
        // this.layoutSize = layout.layout(subLayoutObjects);
        // LayoutConstraintSetter.forwardLayoutConstraints(this);
        this.layoutSize = layout.layout(constraints, parentSize, cast this, cast this.subViews);
    }

    public function build(builder:ViewBuilder) {
    }
}
