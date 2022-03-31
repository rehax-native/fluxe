#include "out/include/examples/text_and_button/TextAndButton.h"

int main() {
  HX_TOP_OF_STACK
  ::hx::Boot();
  __boot_all();
  examples::text_and_button::TextAndButton_obj::main();
  return 0;
}
