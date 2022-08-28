#pragma once

#include <rehaxUtils/pointers/Object.h>
#include "../../shell/callbacks.h"
#include "FocusManager.h"
#include <set>

using namespace rehaxUtils;

namespace fluxe {

class ClipboardManager
{
public:
  ClipboardManager(FocusManager & focusManager);

  void handleClipboardInstruction(ShellClipboardInstruction instruction);
  void copyToClipboard(std::string text);

private:
  FocusManager & focusManager;
};

}
