package fluxe.render_pipeline;

using fluxe.views.View;
using fluxe.views.ViewBuilder;
using fluxe.views.Externs;

class RenderPipeline {
    public function new(view:View) {
        this.rootView = view;
    }
    var rootView:View;
    var viewBuilder = new ViewBuilder();

    var width:Int = 0;
    var height:Int = 0;

    public function render(width:Int, height:Int, scale:Float):RenderSurface {
        this.width = width;
        this.height = height;
        if (this.rootView != null) {
            if (this.rootView.layoutConstraints == null) {
                this.rootView.layoutConstraints = {
                    explicitWidth: null,
                    explicitHeight: null,
                    minWidth: null,
                    minHeight: null,
                    maxWidth: null,
                    maxHeight: null,
                };
            }
            this.rootView.layoutConstraints.maxWidth = width;
            this.rootView.layoutConstraints.maxHeight = height;
        }

        viewBuilder.scale = scale;
        if (viewBuilder.rootNode.surface != null) {
            viewBuilder.rootNode.surface.destroy();
        }
        viewBuilder.rootNode.surface = new RenderSurface(width, height, scale);

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
