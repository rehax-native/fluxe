#pragma once

#include "MouseEventsManager.h"

namespace fluxe {

struct PressStartedEvent {};
struct PressFinishedEvent {};
struct PressCanceledEvent {};

class IPressEventListener : virtual public Object<View>
{
public:
  virtual void onPressStarted(PressStartedEvent event) = 0;
  virtual void onPressFinished(PressFinishedEvent event) = 0;
  virtual void onPressCanceled(PressCanceledEvent event) = 0;
};

class PressDetector : public IMouseDownEventListener, public IMouseUpEventListener, public IMouseEnterExitEventListener
{
public:

  PressDetector(ObjectPointer<IPressEventListener> eventListener);

  void onMouseDown(MouseDownEvent event);
  void onMouseUp(MouseUpEvent event);
  void onMouseEnter(MouseEnterEvent event);
  void onMouseExit(MouseExitEvent event);

private:
  ObjectPointer<IPressEventListener> eventListener;
  bool isPressing = false;
};

}
