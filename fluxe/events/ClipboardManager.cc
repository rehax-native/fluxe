#include "ClipboardManager.h"
#include "../views/View.h"

using namespace fluxe;

ClipboardManager::ClipboardManager(FocusManager & focusManager)
:focusManager(focusManager)
{}

void ClipboardManager::handleClipboardInstruction(ShellClipboardInstruction instruction)
{
  auto currentFocusable = focusManager.getCurrentFocusable();
  if (currentFocusable.isValid()) {
    if (instruction.isPaste) {
//      currentFocusable->onClipboardData(instruction.data);
    }
  }
}

void ClipboardManager::copyToClipboard(std::string text)
{

}
