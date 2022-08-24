#include "PressEvent.h"

using namespace fluxe;

PressDetector::PressDetector(IPressEventListener * eventListener)
:eventListener(eventListener)
{
}

void PressDetector::onMouseDown(MouseDownEvent event)
{
  isPressing = true;
  eventListener->onPressStarted({ .button = event.button, .left = event.left, .top = event.top });
}

void PressDetector::onMouseUp(MouseUpEvent event)
{
  if (isPressing) {
    isPressing = false;
    eventListener->onPressFinished({ .button = event.button, .left = event.left, .top = event.top });
  }
}

void PressDetector::onMouseEnter(MouseEnterEvent event)
{
}

void PressDetector::onMouseExit(MouseExitEvent event)
{
  if (isPressing) {
    isPressing = false;
    eventListener->onPressCanceled({});
  }
}
