#pragma once

#include "third_party/skia/include/core/SkRRect.h"

namespace fluxe {

class RRect {
 public:
  SkRRect sk_rrect;
  bool is_null;
};

}  // namespace fluxe
