#include "out/include/examples/text_and_button/TextAndButton.h"

#if _WIN32
#include <windows.h>

int WINAPI WinMain(HINSTANCE inst, HINSTANCE prev, LPSTR cmd, int show) {
#else
int main() {
#endif
  HX_TOP_OF_STACK
  ::hx::Boot();
  __boot_all();
  examples::text_and_button::TextAndButton_obj::main();
  return 0;
}
