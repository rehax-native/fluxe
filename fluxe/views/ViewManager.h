#pragma once

#include "../misc/Object.h"
#include "render_backend/skia/canvas.h"
#include "../render_pipeline/RenderPipeline.h"
#include "shell/callbacks.h"
#include "ViewsContainer.h"

namespace fluxe {

class ViewManager : public Object<ViewManager>
{
public:

  ViewManager(ObjectPointer<View> view);

  void setNeedsRerender();

  std::function<void (void)> onNeedsRerender;

  // MouseEventsManager getMouseEventsManager();
  // FocusManager getFocusManager();

  sk_sp<Surface> renderCallback(int width, int height, float scale);
  void mouseCallback(ShellMouseInstruction instruction);
  void keyCallback(ShellKeyboardKeyInstruction instruction);
  void textCallback(std::string str);
  void moveCallback(ShellKeyboardMoveInstruction instruction);

  void onViewAdded(ObjectPointer<View> view);
  void onViewRemoved(ObjectPointer<View> view);

private:
  void recollectFocusables();

  ObjectPointer<ViewsContainer> container;
  RenderPipeline pipeline;
};

}
