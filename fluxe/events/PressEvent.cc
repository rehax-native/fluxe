#include "PressEvent.h"

using namespace fluxe;

PressDetector::PressDetector(IPressEventListener * eventListener)
:eventListener(eventListener)
{
}

void PressDetector::onMouseDown(MouseDownEvent & mouseEvent)
{
  isPressing = true;
  PressStartedEvent event { .button = mouseEvent.button, .left = mouseEvent.left, .top = mouseEvent.top };
  eventListener->onPressStarted(event);
  mouseEvent.doesPropagate = event.doesPropagate;
  mouseEvent.doesPropagateToSiblings = event.doesPropagateToSiblings;
}

void PressDetector::onMouseUp(MouseUpEvent & mouseEvent)
{
  if (isPressing) {
    isPressing = false;
    PressFinishedEvent event { .button = mouseEvent.button, .left = mouseEvent.left, .top = mouseEvent.top };
    eventListener->onPressFinished(event);
    mouseEvent.doesPropagate = event.doesPropagate;
    mouseEvent.doesPropagateToSiblings = event.doesPropagateToSiblings;
  }
}

void PressDetector::onMouseEnter(MouseEnterEvent & mouseEvent)
{
}

void PressDetector::onMouseExit(MouseExitEvent & mouseEvent)
{
  if (isPressing) {
    isPressing = false;
    PressCanceledEvent event {};
    eventListener->onPressCanceled(event);
    mouseEvent.doesPropagate = event.doesPropagate;
    mouseEvent.doesPropagateToSiblings = event.doesPropagateToSiblings;
  }
}
