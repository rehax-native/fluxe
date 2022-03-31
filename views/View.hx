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

    var _subViews:Array<View> = [];
    public var subViews(get, null):Array<View>;

    public function get_subViews():Array<View> {
        return [for (i in _subViews) i];
    }

    public function addSubView(view:View) {
        _subViews.push(view);
    }

    public function removeSubView(view:View) {
        _subViews.remove(view);
    }

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
