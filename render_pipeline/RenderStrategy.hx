package render_pipeline;

abstract class RenderStrategy {
    abstract public function shouldCreateNewRasterizeLayer(?tag:Int):Bool;
}

class PaintAlwaysRenderStrategy extends RenderStrategy {
    public function new() {}
    public function shouldCreateNewRasterizeLayer(?tag:Int):Bool {
        return false;
    }
}

class RasterizeAllViewsRenderStrategy extends RenderStrategy {
    public function new() {}
    public function shouldCreateNewRasterizeLayer(?tag:Int):Bool {
        return true;
    }
}
