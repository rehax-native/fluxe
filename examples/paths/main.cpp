#include "out/include/examples/paths/Paths.h"

int main() {
  HX_TOP_OF_STACK
  ::hx::Boot();
  __boot_all();
  examples::paths::Paths_obj::main();
  return 0;
}
