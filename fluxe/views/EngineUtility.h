#pragma once

#include "View.h"
#include "../../shell/callbacks.h"
#include "../../engine.h"

namespace fluxe {

class EngineUtility
{

public:
  static void startWithView(ObjectPointer<View> view);
  static void startWithViewAndPlatformView(ObjectPointer<View> view, void * platformView);

  void initWithWindow(ObjectPointer<View> view, void * window);
  void initWithPlatformView(ObjectPointer<View> view, void * platformView);

  void handleMouseCallback(ShellMouseInstruction instruction);
  void handleKeyCallback(ShellKeyboardKeyInstruction instruction);
  void handleMoveCallback(ShellKeyboardMoveInstruction instruction);

private:
  Engine engine;
  ObjectPointer<ViewManager> viewManager;

};

}
