#include "MouseEventsManager.h"
#include "../views/View.h"
#include "../views/ViewManager.h"

using namespace fluxe;

MouseEventsManager::MouseEventsManager(ViewManager * viewManager, ObjectPointer<View> rootView)
:viewManager(viewManager), rootView(rootView)
{}

void MouseEventsManager::handleInstruction(ShellMouseInstruction instruction)
{
  if (instruction.isDown && !instruction.isMove) {
    MouseDownEvent event {
      .left = instruction.left,
      .top = instruction.top,
      .button = instruction.button,
    };
    handleMouseDown(event);
  } else if (instruction.isUp && !instruction.isMove) {
    MouseUpEvent event {
      .left = instruction.left,
      .top = instruction.top,
      .button = instruction.button,
    };
    handleMouseUp(event);
  } else if (instruction.isMove) {
    MouseMoveEvent event {
      .left = instruction.left,
      .top = instruction.top,
    };
    handleMouseMove(event);
  }
}

void MouseEventsManager::handleMouseDown(MouseDownEvent & event)
{
  isMouseDown = true;
  auto hitView = findViewAtPosition(event.left, event.top, rootView);
  auto contextMenu = viewManager->getContextMenu();
  bool hasContextMenuOpen = hitView.isValid();
  bool shouldCloseContextMenu = false;
  if (hasContextMenuOpen) {
    if (!hitView.isValid() || !(hitView == contextMenu || hitView->isInSubViewTreeOf(contextMenu))) {
      shouldCloseContextMenu = true;
    }
  }

  while (hitView.isValid()) {
    if (!event.doesPropagate) {
      break;
    }
    hitView->onMouseDown(event);
    currentListenersWithMouseDown.insert(hitView);
    hitView = hitView->getParent();
  }

  if (shouldCloseContextMenu) {
    viewManager->closeContextMenu();
  }
}

void MouseEventsManager::handleMouseUp(MouseUpEvent & event)
{
  isMouseDown = false;
  // this sends the mouse up event to the view that is under the mouse. Not sure we want that?
//  auto hitView = findViewAtPosition(event.left, event.top, rootView);
//  while (hitView.isValid()) {
//    hitView->onMouseUp(event);
//    hitView = hitView->getParent();
//  }
  for (auto listener : currentListenersWithMouseDown) {
    if (!event.doesPropagate) {
      break;
    }
    listener->onMouseUp(event);
  }
  currentListenersWithMouseDown.clear();
}

void MouseEventsManager::handleMouseMove(MouseMoveEvent & event)
{
  if (isMouseDown) {
    for (auto listener : currentListenersWithMouseDown) {
    if (!event.doesPropagate) {
      break;
    }
      listener->onMouseMove(event);
    }
  }
  auto hitView = findViewAtPosition(event.left, event.top, rootView);
  std::set<WeakObjectPointer<View>> newListeners;

  while (hitView.isValid()) {
    if (previousMouseMoveListeners.find(hitView) == previousMouseMoveListeners.end()) {
      MouseEnterEvent event {
        .left = event.left,
        .top = event.top,
      };
      hitView->onMouseEnter(event);
    }
    newListeners.insert(hitView);
    if (!isMouseDown) {
      hitView->onMouseMove(event);
    }
    hitView = hitView->getParent();
  }

  for (auto listener : previousMouseMoveListeners) {
    if (newListeners.find(listener) == newListeners.end()) {
      MouseExitEvent event {
        .left = event.left,
        .top = event.top,
      };
      listener->onMouseExit(event);
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
      // for (auto item : subViews) {
      for (auto it = subViews.rbegin(); it != subViews.rend(); it++) {
        auto item = * it;
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
