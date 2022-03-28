package render_pipeline;

class RenderPipeline {
    var rootView:View;
    var viewBuilder = new ViewBuilder();

    public function render() {
        layout()
        build()
        compose()
    }

    function layout() {
        rootView.measureLayout()
    }

    function build() {
        buildTraverse(rootView, viewBuilder);
    }

    function buildTraverse(view:View, viewBuilder:ViewBuilder) {
        viewBuilder.currentRenderStrategy = view.renderStrategy;
        view.build(viewBuilder);
        for (subView in view.subViews) {
            buildTraverse(subViews, viewBuilder);
        }
    }

    function compose() {
        // Paint all different canvases we have from the build phase into one surface
        viewBuilder.compose();
    }
}
