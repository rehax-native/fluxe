package views;

using layout.ILayout;
using layout.ILayoutObject;
using layout.LayoutConstraint;
using layout.LayoutSize;
using layout.LayoutPosition;
using layout.StackLayout;

using views.RenderStrategy;

class View implements ILayoutObject {
    static public var defaultRenderStrategy:RenderStrategy = new RasterizeAllViewsRenderStrategy();
    static function renderStrategy():RenderStrategy {
        return defaultRenderStrategy;
    }

    public function new() {}

    var subViews:Array<View> = [];

    public function addSubView(view:View) {
        subViews.push(view);
    }

    public function removeSubView(view:View) {
        subViews.remove(view);
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
