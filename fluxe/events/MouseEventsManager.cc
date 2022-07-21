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
  // auto hitView = findViewAtPosition(event.left, event.top, rootView);
  // while (hitView.hasPointer()) {
  //   if (hitView->doesSupportEventListener(IMouseDownEventListener::EventName))
  //   {
  //     var eventView = cast(hitView, IMouseEventListenerContainer);
  //     for (listener in eventView.mouseEventListeners) {
  //       if (Std.isOfType(listener, IMouseDownEventListener)) {
  //         cast(listener, IMouseDownEventListener).onMouseDown(event);
  //       }
  //     }
  //   }
  //   if (Std.isOfType(hitView, IMouseDownEventListener)) {
  //     cast(hitView, IMouseDownEventListener).onMouseDown(event);
  //   }
  //   hitView = hitView.parent;
  // }
}

void MouseEventsManager::handleMouseUp(MouseUpEvent event)
{
  // auto hitView = findViewAtPosition(event.left, event.top, rootView);
  // while (hitView != null) {
  //   if (Std.isOfType(hitView, IMouseEventListenerContainer)) {
  //     var eventView = cast(hitView, IMouseEventListenerContainer);
  //     for (listener in eventView.mouseEventListeners) {
  //       if (Std.isOfType(listener, IMouseUpEventListener)) {
  //         cast(listener, IMouseUpEventListener).onMouseUp(event);
  //       }
  //     }
  //   }
  //   if (Std.isOfType(hitView, IMouseUpEventListener)) {
  //     cast(hitView, IMouseUpEventListener).onMouseUp(event);
  //   }
  //   hitView = hitView.parent;
  // }
}

void MouseEventsManager::handleMouseMove(MouseMoveEvent event)
{
  // auto hitView = findViewAtPosition(event.left, event.top, rootView);
  // var newListeners:Map<IMouseEnterExitEventListener, Bool> = [];
  // while (hitView != null) {
  //     if (Std.isOfType(hitView, IMouseEventListenerContainer)) {
  //         var eventView = cast(hitView, IMouseEventListenerContainer);
  //         for (listener in eventView.mouseEventListeners) {
  //             if (Std.isOfType(listener, IMouseEnterExitEventListener)) {
  //                 var enterListener = cast(listener, IMouseEnterExitEventListener);
  //                 if (!previousMouseMoveListeners.exists(enterListener)) {
  //                     previousMouseMoveListeners[enterListener] = true;
  //                     enterListener.onMouseEnter(event);
  //                 }
  //                 newListeners[enterListener] = true;
  //             }
  //             if (Std.isOfType(listener, IMouseMoveEventListener)) {
  //                 var moveListener = cast(listener, IMouseMoveEventListener);
  //                 moveListener.onMouseMove(event);
  //             }
  //         }
  //     }
  //     if (Std.isOfType(hitView, IMouseEnterExitEventListener)) {
  //         var enterListener = cast(hitView, IMouseEnterExitEventListener);
  //         if (!previousMouseMoveListeners.exists(enterListener)) {
  //             previousMouseMoveListeners[enterListener] = true;
  //             enterListener.onMouseEnter(event);
  //         }
  //         newListeners[enterListener] = true;
  //     }
  //     if (Std.isOfType(hitView, IMouseMoveEventListener)) {
  //         var moveListener = cast(hitView, IMouseMoveEventListener);
  //         moveListener.onMouseMove(event);
  //     }
  //     hitView = hitView.parent;
  // }

  // for (listener in previousMouseMoveListeners.keys()) {
  //     if (Std.isOfType(listener, IMouseEnterExitEventListener)) {
  //         var exitListener = cast(listener, IMouseEnterExitEventListener);
  //         if (!newListeners.exists(exitListener)) {
  //             exitListener.onMouseExit(event);
  //             previousMouseMoveListeners.remove(exitListener);
  //         }
  //     }
  // }
}

ObjectPointer<View> MouseEventsManager::findViewAtPosition(float x, float y, ObjectPointer<View> view)
{
  // if (view.layoutPosition == null || view.layoutSize == null) {
  //     return null;
  // }
  // if (x >= view.layoutPosition.left && x <= view.layoutPosition.left + view.layoutSize.width) {
  //     if (y >= view.layoutPosition.top && y <= view.layoutPosition.top + view.layoutSize.height) {
  //         var subViews = view.subViews;
  //         for (item in subViews) {
  //             var hitView = findViewAtPosition(x - view.layoutPosition.left, y - view.layoutPosition.top, item);
  //             if (hitView != null) {
  //                 return hitView;
  //             }
  //         }
  //         return view;
  //     }
  // }
  // return null;
}