package fluxe.views;

class SmartScrollViewRenderStrategy extends RenderStrategy {
    public function shouldCreateNewRasterizeLayer(?tag:Int):Bool {
        return true;
    }
}

class ScrollView extends View {
    static var defaultScrollviewRenderStrategy:RenderStrategy = SmartScrollViewRenderStrategy()
    static override function renderStrategy():RenderStrategy {
        return defaultScrollviewRenderStrategy;
    }

    function paint(canvas:Canvas):Void {

    }

    function build(builder:ViewBuilder) {
        builder.pushLayer();
        for (item in items) {
            builder.pushLayer();
            item.build(builder);
            builder.popLayer();
        }
        builder.pushLayer();
        builder.canvas.drawRect();
        builder.popLayer();
    }
}