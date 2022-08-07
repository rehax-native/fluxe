#include "MouseEventsManager.h"
#include "../views/View.h"

using namespace fluxe;

MouseEventsManager::MouseEventsManager(ObjectPointer<View> rootView)
:rootView(rootView)
{}

void MouseEventsManager::handleInstruction(ShellMouseInstruction instruction)
{
  if (instruction.isDown && !instruction.isMove) {
    handleMouseDown({
      .left = instruction.left,
      .top = instruction.top,
      .button = instruction.button,
    });
  } else if (instruction.isUp && !instruction.isMove) {
    handleMouseUp({
      .left = instruction.left,
      .top = instruction.top,
      .button = instruction.button,
    });
  } else if (instruction.isMove) {
    handleMouseMove({
      .left = instruction.left,
      .top = instruction.top,
    });
  }
}

void MouseEventsManager::handleMouseDown(MouseDownEvent event)
{
  isMouseDown = true;
  auto hitView = findViewAtPosition(event.left, event.top, rootView);
  while (hitView.isValid()) {
    hitView->onMouseDown(event);
    currentListenersWithMouseDown.insert(hitView);
    hitView = hitView->getParent();
  }
}

void MouseEventsManager::handleMouseUp(MouseUpEvent event)
{
  isMouseDown = false;
  // this sends the mouse up event to the view that is under the mouse. Not sure we want that?
//  auto hitView = findViewAtPosition(event.left, event.top, rootView);
//  while (hitView.isValid()) {
//    hitView->onMouseUp(event);
//    hitView = hitView->getParent();
//  }
  for (auto listener : currentListenersWithMouseDown) {
    listener->onMouseUp(event);
  }
  currentListenersWithMouseDown.clear();
}

void MouseEventsManager::handleMouseMove(MouseMoveEvent event)
{
  if (isMouseDown) {
    for (auto listener : currentListenersWithMouseDown) {
      listener->onMouseMove(event);
    }
  }
  auto hitView = findViewAtPosition(event.left, event.top, rootView);
  std::set<WeakObjectPointer<View>> newListeners;

  while (hitView.isValid()) {
    if (previousMouseMoveListeners.find(hitView) == previousMouseMoveListeners.end()) {
      hitView->onMouseEnter(MouseEnterEvent {
        .left = event.left,
        .top = event.top,
      });
    }
    newListeners.insert(hitView);
    if (!isMouseDown) {
      hitView->onMouseMove(event);
    }
    hitView = hitView->getParent();
  }

  for (auto listener : previousMouseMoveListeners) {
    if (newListeners.find(listener) == newListeners.end()) {
      listener->onMouseExit(MouseExitEvent {
        .left = event.left,
        .top = event.top,
      });
    }
  }

  previousMouseMoveListeners = newListeners;
}

WeakObjectPointer<View> MouseEventsManager::findViewAtPosition(float x, float y, ObjectPointer<View> view)
{
  if (!view->layoutPosition.isSet || !view->layoutSize.isSet) {
    return WeakObjectPointer<View>();
  }
  if (x >= view->layoutPosition.value.left && x <= view->layoutPosition.value.left + view->layoutSize.value.width) {
    if (y >= view->layoutPosition.value.top && y <= view->layoutPosition.value.top + view->layoutSize.value.height) {
      auto subViews = view->getSubViews();
      for (auto item : subViews) {
        auto hitView = findViewAtPosition(x - view->layoutPosition.value.left, y - view->layoutPosition.value.top, item);
        if (hitView.isValid()) {
          return hitView;
        }
      }
      return view;
    }
  }
  return WeakObjectPointer<View>();
}
