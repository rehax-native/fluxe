#include "FocusManager.h"
#include "../views/ViewManager.h"

using namespace fluxe;

WeakObjectPointer<View> FocusManager::getCurrentFocusable()
{
  return currentFocusable;
}

void FocusManager::gainFocus(ObjectPointer<View> view)
{
  if (currentFocusable.isValid() && view.hasPointer() && currentFocusable.get() != view.get()) {
    loseFocus();
  }
  currentFocusable = view;
  currentFocusable->didGainFocus();
}

void FocusManager::loseFocus()
{
  if (currentFocusable.isValid()) {
    currentFocusable->didLoseFocus();
    currentFocusable = WeakObjectPointer<View>();
  }
}

void FocusManager::focusNext()
{

}

void FocusManager::focusPrevious()
{

}

    // public function focusNext():Void {
    //     var prev = currentFocusable;
    //     if (focusables.length > 0) {
    //         if (currentFocusable == null) {
    //             currentFocusable = focusables[0];
    //         } else {
    //             var index = focusables.indexOf(currentFocusable);
    //             index = (index + 1) % focusables.length;
    //             if (index < focusables.length) {
    //                 currentFocusable = focusables[index];
    //             } else {
    //                 currentFocusable = null;
    //             }
    //         }
    //     } else {
    //         currentFocusable = null;
    //     }

    //     if (prev != null) {
    //         prev.didLoseFocus();
    //     }
    //     if (currentFocusable != null) {
    //         currentFocusable.didGainFocus();
    //     }
    // }

    // public function focusPrevious():Void {
    //     var prev = currentFocusable;
    //     if (focusables.length > 0) {
    //         if (currentFocusable == null) {
    //             currentFocusable = focusables[0];
    //         } else {
    //             var index = focusables.indexOf(currentFocusable) - 1;
    //             if (index < 0) {
    //                 index = focusables.length - 1;
    //             }
    //             if (index < focusables.length) {
    //                 currentFocusable = focusables[index];
    //             } else {
    //                 currentFocusable = null;
    //             }
    //         }
    //     } else {
    //         currentFocusable = null;
    //     }

    //     if (prev != null) {
    //         prev.didLoseFocus();
    //     }
    //     if (currentFocusable != null) {
    //         currentFocusable.didGainFocus();
    //     }
    // }
