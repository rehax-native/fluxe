#pragma once

#include "MouseEvents.h"
#include "IEventListener.h"

namespace fluxe {

struct PressEvent {
  void stopPropagation() {
    doesPropagate = false;
  }
  void stopImmediatePropagation() {
    doesPropagateToSiblings = false;
  }

  bool doesPropagate = true;
  bool doesPropagateToSiblings = true;
};

struct PressStartedEvent : PressEvent {
  int button = 0;
  float left;
  float top;
};
struct PressFinishedEvent : PressEvent {
  int button = 0;
  float left;
  float top;
};
struct PressCanceledEvent : PressEvent {};

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
