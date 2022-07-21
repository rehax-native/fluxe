#include "ViewsContainer.h"
#include "ViewManager.h"

using namespace fluxe;

ViewsContainer::ViewsContainer(ObjectPointer<ViewManager> viewManager)
:viewManager(viewManager)
{
  layoutPosition = Nullable<LayoutPosition>({ .left = 0, .top = 0 });
}

WeakObjectPointer<ViewManager> ViewsContainer::getViewManager()
{
  return viewManager;
}

void ViewsContainer::setNeedsRerender(bool needsRerender)
{
  if (needsRerender)
  {
    viewManager->setNeedsRerender();
  }
}