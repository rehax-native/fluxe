#include "out/include/examples/layouts/Layout.h"

int main() {
  HX_TOP_OF_STACK
  ::hx::Boot();
  __boot_all();
  examples::layouts::Layout_obj::main();
  return 0;
}
