#include "IEventListener.h"
#include <iostream>

using namespace fluxe;

void IEventListener::onMouseDown(MouseDownEvent & event)
{}

void IEventListener::onMouseUp(MouseUpEvent & event)
{}

void IEventListener::onMouseMove(MouseMoveEvent & event)
{}

void IEventListener::onMouseEnter(MouseEnterEvent & event)
{}

void IEventListener::onMouseExit(MouseExitEvent & event)
{}

bool IEventListener::isFocusable()
{
  return false;
}

void IEventListener::didGainFocus()
{}

void IEventListener::didLoseFocus()
{}

void IEventListener::onTextInput(std::string text)
{}

void IEventListener::onKeyboardMoveAction(ShellKeyboardMoveInstruction event)
{}

bool IEventListener::isHandlingKeyboardCommand(ShellKeyboardCommand command)
{
  return false;
}

void IEventListener::onKeyboardCommand(ShellKeyboardCommand command)
{}

void IEventListener::onClipboardData(ShellClipboardData data)
{}

IEventListenerContainer::~IEventListenerContainer()
{
  for (auto listener : eventListeners) {
    delete listener;
  }
}

void IEventListenerContainer::onMouseDown(MouseDownEvent & event)
{
  for (auto listener : eventListeners) {
    if (!event.doesPropagateToSiblings) {
      break;
    }
    listener->onMouseDown(event);
  }
}

void IEventListenerContainer::onMouseUp(MouseUpEvent & event)
{
  for (auto listener : eventListeners) {
    if (!event.doesPropagateToSiblings) {
      break;
    }
    listener->onMouseUp(event);
  }
}

void IEventListenerContainer::onMouseMove(MouseMoveEvent & event)
{
  for (auto listener : eventListeners) {
    if (!event.doesPropagateToSiblings) {
      break;
    }
    listener->onMouseMove(event);
  }
}

void IEventListenerContainer::onMouseEnter(MouseEnterEvent & event)
{
  for (auto listener : eventListeners) {
    if (!event.doesPropagateToSiblings) {
      break;
    }
    listener->onMouseEnter(event);
  }
}

void IEventListenerContainer::onMouseExit(MouseExitEvent & event)
{
  for (auto listener : eventListeners) {
    if (!event.doesPropagateToSiblings) {
      break;
    }
    listener->onMouseExit(event);
  }
}
