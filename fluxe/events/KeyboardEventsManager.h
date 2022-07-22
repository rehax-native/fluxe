#pragma once

#include "FocusManager.h"
#include "../../shell/callbacks.h"

namespace fluxe {

class KeyboardEventsManager
{
public:
  KeyboardEventsManager(FocusManager & focusManager);
  void onTextInput(std::string text);
  void onKeyboardMoveAction(ShellKeyboardMoveInstruction event);
private:
  FocusManager & focusManager;
};

}
