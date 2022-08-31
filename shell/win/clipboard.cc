#include "clipboard.h"
#include <Windows.h>

using namespace fluxe;

void Clipboard::copyStringToClipboard(std::string text) {
  HGLOBAL hMem = GlobalAlloc(GMEM_MOVEABLE, text.size() + 1);
  memcpy(GlobalLock(hMem), text.c_str(), text.size());
  GlobalUnlock(hMem);
  OpenClipboard(0);
  EmptyClipboard();
  SetClipboardData(CF_TEXT, hMem);
  CloseClipboard();
}

std::string Clipboard::pasteStringFromClipboard() {
  if (!IsClipboardFormatAvailable(CF_TEXT)) {
    return "";
  }

  HGLOBAL   hglb; 
  LPTSTR    lptstr; 
  OpenClipboard(0);

  hglb = GetClipboardData(CF_TEXT); 
  if (hglb != NULL) { 
      lptstr = (LPTSTR) GlobalLock(hglb); 
      if (lptstr != NULL) { 
          GlobalUnlock(hglb); 
      } 
  } 
  CloseClipboard(); 
  return std::string(lptstr);
}
