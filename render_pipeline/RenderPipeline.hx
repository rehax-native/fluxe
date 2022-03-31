package render_pipeline;

using views.View;
using views.ViewBuilder;
using views.Externs;

class RenderPipeline {
    public function new(view:View) {
        this.rootView = view;
    }
    var rootView:View;
    var viewBuilder = new ViewBuilder();

    var width:Int = 0;
    var height:Int = 0;

    public function render(width:Int, height:Int):RenderSurface {
        this.width = width;
        this.height = height;
        viewBuilder.rootNode.surface = new RenderSurface(width, height);

        layout();
        build();
        // compose();

        return viewBuilder.rootNode.surface;
    }

    public function layout() {
        rootView.measureLayout();
    }

    public function build() {
        buildTraverse(rootView, viewBuilder);
    }

    function buildTraverse(view:View, viewBuilder:ViewBuilder) {
        viewBuilder.currentRenderStrategy = view.renderStrategy();
        var dx = 0.0;
        var dy = 0.0;
        if (view.layoutPosition != null) {
            dx = view.layoutPosition.left;
            dy = view.layoutPosition.top;
        }
        viewBuilder.canvas.translate(dx, dy);
        view.build(viewBuilder);
        var subViews = view.subViews;
        for (subView in subViews) {
            buildTraverse(subView, viewBuilder);
        }
        viewBuilder.canvas.translate(-dx, -dy);
    }

    public function compose() {
        // Paint all different canvases we have from the build phase into one surface
        viewBuilder.compose();
    }
}
