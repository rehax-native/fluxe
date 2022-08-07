#include "PressEvent.h"

using namespace fluxe;

PressDetector::PressDetector(IPressEventListener * eventListener)
:eventListener(eventListener)
{
}

void PressDetector::onMouseDown(MouseDownEvent event)
{
  isPressing = true;
  eventListener->onPressStarted({});
}

void PressDetector::onMouseUp(MouseUpEvent event)
{
  if (isPressing) {
    isPressing = false;
    eventListener->onPressFinished({});
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
