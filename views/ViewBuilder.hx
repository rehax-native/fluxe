package views;

using views.Externs;
using render_pipeline.RenderStrategy;

class ViewBuilder {
    public function new() {}

    public var currentRenderStrategy:RenderStrategy = View.defaultRenderStrategy;
    var layers:Array<ViewBuilder> = [];

    public var surface:RenderSurface;
    public var canvas(get, null):Canvas;

    public function get_canvas() {
        return surface.getCanvas();
    }

    public function pushLayer(?tag:Int):ViewBuilder {
        if (currentRenderStrategy.shouldCreateNewRasterizeLayer(tag)) {
            var layer = new ViewBuilder();
            layers.push(layer);
            return layer;
        }
        return layers[layers.length - 1];
    }

    public function popLayer(?tag:Int):ViewBuilder {
        if (currentRenderStrategy.shouldCreateNewRasterizeLayer(tag)) {
            layers.pop();
        }
        return layers[layers.length - 1];
    }

    public function compose() {
        this.canvas;
    }
}
