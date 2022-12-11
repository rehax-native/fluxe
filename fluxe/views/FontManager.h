#pragma once

#include "View.h"
#include <modules/skparagraph/include/TypefaceFontProvider.h>

namespace fluxe {

class FontManager
{
public:
  static FontManager & Shared();
  void addFontFromPath(std::string path);
    
  sk_sp<FontCollection> getFontCollection();
  SkFont getDefaultFont();

private:
  static FontManager sharedManager;
  FontManager();
  sk_sp<FontCollection> collection;
  sk_sp<skia::textlayout::TypefaceFontProvider> fontProvider = sk_make_sp<skia::textlayout::TypefaceFontProvider>();
};

}
