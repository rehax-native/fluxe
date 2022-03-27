package views;

class View {
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

    var left:Float;
    var top:Float;
    var width:Float;
    var height:Float;
    var right:Float;
    var bottom:Float;

    function layout():Void {
        var minWidth, minHeight, maxWidth, maxHeight;
        for (child in subViews) {
            child.layout();
        }
    }

    function build(builder:ViewBuilder) {
    }
}
