#pragma once

#include <rehaxUtils/pointers/Object.h>
#include "../views/View.h"

using namespace rehaxUtils;

namespace fluxe {

class RenderPipeline
{
public:
    RenderPipeline(ObjectPointer<View> view);

    sk_sp<Surface> render(int width, int height, float scale, sk_sp<SkSurface> surface);
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
