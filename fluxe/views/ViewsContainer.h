#pragma once

#include "../misc/Object.h"
#include "render_backend/skia/canvas.h"
#include "View.h"
#include "../render_pipeline/RenderPipeline.h"

namespace fluxe {

class ViewManager;

/**
  This is the root of view used by the view manager.
  It is calling back to the view manager for certain things that happen in the view hierarchy,
  as the descendant views are calling out to the parent views.
*/
class ViewsContainer : public View
{
public:
  ViewsContainer(ObjectPointer<ViewManager> viewManager);

  WeakObjectPointer<ViewManager> getViewManager() override;
  void setNeedsRerender(bool needsRerender) override;
private:
  ObjectPointer<ViewManager> viewManager;
};

}
