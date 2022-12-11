#include "RenderPipeline.h"
#include <rehaxUtils/app/app.h>
#include "../views/FontManager.h"

using namespace fluxe;

RenderPipeline::RenderPipeline(ObjectPointer<View> view)
:rootView(view),
viewBuilder(Object<ViewBuilder>::Create())
{}

sk_sp<Surface> RenderPipeline::render(int width, int height, float scale, sk_sp<SkSurface> surface)
{
    if (this->width != width || this->height != height) {
        this->width = width;
        this->height = height;
    }

    viewBuilder->scale = scale;
    viewBuilder->rootNode->surface = surface;

    if (rehaxUtils::App::getApplicationTheme() == rehaxUtils::App::ApplicationTheme::SystemLight) {
        viewBuilder->rootNode->surface->getCanvas()->clear(::fluxe::Color::RGBA(0.944, 0.944, 0.944, 1.0).color);
    } else {
        viewBuilder->rootNode->surface->getCanvas()->clear(::fluxe::Color::RGBA(0.156, 0.156, 0.156, 1.0).color);
    }
    viewBuilder->rootNode->surface->getCanvas()->resetMatrix();
    
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
        .width = Nullable<float>(width),
        .height = Nullable<float>(height),
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

void RenderPipeline::setDebugViews(bool debug)
{
    debugViews = debug;
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
    if (debugViews) {
        static Color bgColors[] = {
          Color::RGBA(1, 0.2, 0.2, 0.10),
          Color::RGBA(0.2, 1, 0.2, 0.10),
          Color::RGBA(0.2, 0.2, 1, 0.10),
        };
        static Color textColors[] = {
          Color::RGBA(1, 0.5, 0.5, 0.5),
          Color::RGBA(0.5, 1, 0.5, 0.5),
          Color::RGBA(0.5, 0.5, 1, 0.5),
        };
        static int colorIndex = 0;
        colorIndex = (colorIndex + 1) % 3;
      
        auto rect = Rect::MakeXYWH(0, 0, view->layoutSize.value.width, view->layoutSize.value.height);
        Paint paint;
        paint.setColor(Color::RGBA(1, 1, 1, 0.5).color);
        paint.setStyle(Paint::Style::kStroke_Style);
        viewBuilder->getCanvas()->drawRect(rect, paint);

        paint.setColor(bgColors[colorIndex].color);
        paint.setStyle(Paint::Style::kFill_Style);
        viewBuilder->getCanvas()->drawRect(rect, paint);

        paint.setColor(textColors[colorIndex].color);
        auto font = FontManager::Shared().getDefaultFont();
      
        auto x = viewBuilder->getCanvas()->getTotalMatrix().getTranslateX() / viewBuilder->getCanvas()->getTotalMatrix().getScaleX();
        auto y = viewBuilder->getCanvas()->getTotalMatrix().getTranslateY() / viewBuilder->getCanvas()->getTotalMatrix().getScaleY();

        std::string description = std::string(view->description()) + " x:" + std::to_string((int) x) + " y:" + std::to_string((int) y) + " " + std::to_string((int) view->layoutSize.value.width) + "x" + std::to_string((int) view->layoutSize.value.height);
        viewBuilder->getCanvas()->drawSimpleText(description.c_str(), strlen(description.c_str()), SkTextEncoding::kUTF8, 0, 0, font, paint);
    }
    view->buildEnter(viewBuilder);
    view->build(viewBuilder);
    auto subViews = view->getSubViews();
    for (auto & subView : subViews) {
        buildTraverse(subView, viewBuilder);
    }
    view->buildExit(viewBuilder);
    viewBuilder->getCanvas()->translate(-dx, -dy);
}

void RenderPipeline::compose()
{
    // Paint all different canvases we have from the build phase into one surface
    viewBuilder->compose();
}
