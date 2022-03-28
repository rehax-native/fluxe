package views;

class View implements ILayoutObject {
    static var defaultRenderStrategy:RenderStrategy = RasterizeAllViewsRenderStrategy()
    static function renderStrategy():RenderStrategy {
        return renderStrategy;
    }

    var subViews:Array<View> = [];

    function addSubView(view:View) {
        subViews.push(view);
    }

    function removeSubView(view:View) {
        subViews.remove(view);
    }

    var layout:Null<ILayout> = null;

    function measureLayout():Void {
        var layout = this.layout;
        if (layout == null) {
            layout = new StackLayout();
        }
        this.layoutSize = layout.layout(this.subViews);
    }

    function build(builder:ViewBuilder) {
    }
}
