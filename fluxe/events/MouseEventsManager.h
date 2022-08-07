#pragma once

#include <rehaxUtils/pointers/Object.h>
#include "../../shell/callbacks.h"
#include "MouseEvents.h"
#include <set>

using namespace rehaxUtils;

namespace fluxe {

class View;

class MouseEventsManager 
{
public:
  MouseEventsManager(ObjectPointer<View> rootView);

  void handleInstruction(ShellMouseInstruction instruction);
  void handleMouseDown(MouseDownEvent event);
  void handleMouseUp(MouseUpEvent event);
  void handleMouseMove(MouseMoveEvent event);

private:
  WeakObjectPointer<View> findViewAtPosition(float x, float y, ObjectPointer<View> view);

  ObjectPointer<View> rootView;
  bool isMouseDown = false;
  std::set<WeakObjectPointer<View>> previousMouseMoveListeners;
  std::set<WeakObjectPointer<View>> currentListenersWithMouseDown;
};

}
