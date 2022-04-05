package views;

using layout.ILayout;
using layout.ILayoutObject;
using layout.LayoutConstraint;
using layout.LayoutSize;
using layout.LayoutPosition;
using layout.StackLayout;

using render_pipeline.RenderStrategy;

class View implements ILayoutObject {
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

    public var layout:Null<ILayout> = null;
    public var layoutConstraints:Null<LayoutConstraint>;
    public var layoutSize:Null<LayoutSize>;
    public var layoutPosition:Null<LayoutPosition>;

    public function measureLayout():Void {
        var layout = this.layout;
        if (layout == null) {
            layout = new StackLayout();
        }
        // var subLayoutObjects = cast(this.subViews, Array<Dynamic>);
        // this.layoutSize = layout.layout(subLayoutObjects);
        this.layoutSize = layout.layout(cast this.subViews);
    }

    public function build(builder:ViewBuilder) {
    }
}
