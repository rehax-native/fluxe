#pragma once

#include <iostream>

namespace fluxe {

class Clipboard {
public:
  static void copyStringToClipboard(std::string text);
  static std::string pasteStringFromClipboard();
};

}
