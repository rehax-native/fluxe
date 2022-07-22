#pragma once

#include "MouseEvents.h"
#include "IEventListener.h"

namespace fluxe {

struct PressStartedEvent {};
struct PressFinishedEvent {};
struct PressCanceledEvent {};

class IPressEventListener
{
public:
  virtual void onPressStarted(PressStartedEvent event) = 0;
  virtual void onPressFinished(PressFinishedEvent event) = 0;
  virtual void onPressCanceled(PressCanceledEvent event) = 0;
};

class PressDetector : public IEventListener
{
public:
  PressDetector(IPressEventListener * eventListener);

  void onMouseDown(MouseDownEvent event) override;
  void onMouseUp(MouseUpEvent event) override;
  void onMouseEnter(MouseEnterEvent event) override;
  void onMouseExit(MouseExitEvent event) override;

private:
  IPressEventListener * eventListener;
  bool isPressing = false;
};

}
