#pragma once

#include "../misc/Object.h"
#include "../views/View.h"

namespace fluxe {

class RenderPipeline
{
public:
    RenderPipeline(ObjectPointer<View> view);

    sk_sp<Surface> render(int width, int height, float scale);
    void layout();
    void build();
    void compose();

protected:

    void layoutResetTraverse(ObjectPointer<View> view);
    void buildTraverse(ObjectPointer<View> view, ObjectPointer<ViewBuilder> viewBuilder);

    ObjectPointer<View> rootView;
    ObjectPointer<ViewBuilder> viewBuilder;

    int width = 0;
    int height = 0;

};

}
