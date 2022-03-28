package views;

class ViewBuilder {
    var currentRenderStrategy:RenderStrategy = View.defaultRenderStrategy;
    var layers:Array<Layer> = [];

    public var canvas:Canvas;

    public function pushLayer(?tag:Int):Layer {
        if (currentRenderStrategy.shouldCreateNewRasterizeLayer(tag)) {
            var layer = new Layer();
            layers[layers.length - 1].addSubLayer(layer);
            layers.push(layer);
            return layer;
        }
        return layers[layers.length - 1];
    }

    public function popLayer(?tag:Int):Layer {
        if (currentRenderStrategy.shouldCreateNewRasterizeLayer(tag)) {
            layers.pop(layer);
        }
        return layers[layers.length - 1];
    }

    public function compose() {
        this.canvas;
    }
}
