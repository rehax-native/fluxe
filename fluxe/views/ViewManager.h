#pragma once

#include <rehaxUtils/pointers/Object.h>
#include "render_backend/skia/canvas.h"
#include "../render_pipeline/RenderPipeline.h"
#include "shell/callbacks.h"
#include "ViewsContainer.h"
#include "../events/MouseEventsManager.h"
#include "../events/FocusManager.h"
#include "../events/KeyboardEventsManager.h"
#include "../events/ClipboardManager.h"

namespace fluxe {

class ViewManager : public Object<ViewManager>
{
public:

  ViewManager(ObjectPointer<View> view);

  void setNeedsRerender();

  std::function<void (void)> onNeedsRerender;

  // MouseEventsManager getMouseEventsManager();
  FocusManager & getFocusManager();

  void renderCallback(int width, int height, float scale, sk_sp<SkSurface> surface);
  void mouseCallback(ShellMouseInstruction instruction);
  void keyCallback(ShellKeyboardKeyInstruction instruction);
  void textCallback(std::string str);
  void moveCallback(ShellKeyboardMoveInstruction instruction);
  bool isHandlingKeyboardCommand(ShellKeyboardCommand instruction);
  void handleKeyboardCommand(ShellKeyboardCommand instruction);
  // void clipboardCallback(ShellClipboardInstruction instruction);

  void onViewAdded(ObjectPointer<View> view);
  void onViewRemoved(ObjectPointer<View> view);

  void showContextMenu(ObjectPointer<View> view);
  ObjectPointer<View> getContextMenu();
  void closeContextMenu();

  void setDebugViews(bool debug);

private:
  ObjectPointer<ViewsContainer> container;
  ObjectPointer<View> contextMenu;
  RenderPipeline pipeline;
  bool hasRenderedOnce = false;
  MouseEventsManager mouseEventsManager;
  FocusManager focusManager;
  KeyboardEventsManager keyboardEventsManager;
  ClipboardManager clipboardManager;
};

}
