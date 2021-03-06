#include "RenderPipeline.h"

using namespace fluxe;

RenderPipeline::RenderPipeline(ObjectPointer<View> view)
:rootView(view),
viewBuilder(Object<ViewBuilder>::Create())
{}

sk_sp<Surface> RenderPipeline::render(int width, int height, float scale)
{
    this->width = width;
    this->height = height;
    // if (this.rootView.isSet) {
    //     if (this.rootView.layoutConstraints == null) {
    //         this.rootView.layoutConstraints = {
    //             minWidth: null,
    //             minHeight: null,
    //             maxWidth: null,
    //             maxHeight: null,
    //         };
    //     }
    //     this.rootView.layoutConstraints.maxWidth = width;
    //     this.rootView.layoutConstraints.maxHeight = height;
    // }

    viewBuilder->scale = scale;
    viewBuilder->rootNode->surface = fluxe::Surface::MakeRasterN32Premul(width, height);

    auto canvas = viewBuilder->rootNode->surface->getCanvas();
    canvas->scale(scale, scale);

    layout();
    build();
    // compose();

    return viewBuilder->rootNode->surface;
}

void RenderPipeline::layout()
{
    layoutResetTraverse(rootView);
    rootView->layoutPosition = Nullable<LayoutPosition>({
        .left = 0,
        .top = 0,
    });
    rootView->measureLayout({
        .minWidth = Nullable<float>(),
        .minHeight = Nullable<float>(),
        .maxWidth = Nullable<float>(width),
        .maxHeight = Nullable<float>(height),
    }, {
        .width = width,
        .height = height,
    });
}

void RenderPipeline::layoutResetTraverse(ObjectPointer<View> view)
{
    view->layoutPosition.unset();
    view->layoutSize.unset();
    auto subViews = view->getSubViews();
    for (auto & subView : subViews) {
        layoutResetTraverse(subView);
    }
}

void RenderPipeline::build()
{
    buildTraverse(rootView, viewBuilder);
}

void RenderPipeline::buildTraverse(ObjectPointer<View> view, ObjectPointer<ViewBuilder> viewBuilder)
{
    viewBuilder->currentRenderStrategy = view->renderStrategy();
    float dx = 0.0;
    float dy = 0.0;
    if (view->layoutPosition.isSet) {
        dx = view->layoutPosition.value.left;
        dy = view->layoutPosition.value.top;
    }
    viewBuilder->getCanvas()->translate(dx, dy);
    view->build(viewBuilder);
    auto subViews = view->getSubViews();
    for (auto & subView : subViews) {
        buildTraverse(subView, viewBuilder);
    }
    viewBuilder->getCanvas()->translate(-dx, -dy);
}

void RenderPipeline::compose()
{
    // Paint all different canvases we have from the build phase into one surface
    viewBuilder->compose();
}