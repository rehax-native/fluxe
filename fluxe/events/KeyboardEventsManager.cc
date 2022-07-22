#include "KeyboardEventsManager.h"
#include "../views/View.h"

using namespace fluxe;

KeyboardEventsManager::KeyboardEventsManager(FocusManager & focusManager)
:focusManager(focusManager)
{}

void KeyboardEventsManager::onTextInput(std::string text)
{
  auto currentFocusable = focusManager.getCurrentFocusable();
  if (currentFocusable.isValid()) {
    currentFocusable->onTextInput(text);
  }
}

void KeyboardEventsManager::onKeyboardMoveAction(ShellKeyboardMoveInstruction event)
{
  auto currentFocusable = focusManager.getCurrentFocusable();
  if (currentFocusable.isValid()) {
    currentFocusable->onKeyboardMoveAction(event);
  }
}
