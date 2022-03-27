package render_pipeline;

class RenderPipeline {
    var rootView:View;

    public function render() {
        layout()
        build()
        compose()
    }

    function build() {
        var viewBuilder = new ViewBuilder();
        buildTraverse(rootView, viewBuilder);
    }

    function buildTraverse(view:View, viewBuilder:ViewBuilder) {
        viewBuilder.currentRenderStrategy = view.renderStrategy;
        view.build(viewBuilder);
        for (var i = 0; i < view.subViews.length; i++) {
            buildTraverse(view.subViews[i], viewBuilder);
        }
    }

    function layout() {
        rootView.layout()
    }

    function compose() {
        // Paint all different canvases we have from the build phase into one surface
    }
}
