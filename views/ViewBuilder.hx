package views;

using views.Externs;

class ViewBuilder {
    public function new() {}

    var currentRenderStrategy:RenderStrategy = View.defaultRenderStrategy;
    var layers:Array<ViewBuilder> = [];

    public var canvas:Canvas = new Canvas();

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
