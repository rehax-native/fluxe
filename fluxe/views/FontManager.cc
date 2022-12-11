#include "FontManager.h"

using namespace fluxe;

FontManager FontManager::sharedManager;

FontManager & FontManager::Shared()
{
  return sharedManager;
}

FontManager::FontManager()
{
  collection = sk_make_sp<FontCollection>();
  collection->setDefaultFontManager(SkFontMgr::RefDefault());
}

void FontManager::addFontFromPath(std::string path)
{
  collection->setAssetFontManager(fontProvider);

  auto font = SkFontMgr::RefDefault()->makeFromFile(path.c_str());
  if (font != nullptr) {
    fontProvider->registerTypeface(SkTypeface::MakeFromFile(path.c_str()));
//    SkString name;
//    font->getFamilyName(&name);
  }
}

sk_sp<FontCollection> FontManager::getFontCollection()
{
  return collection;
}

SkFont FontManager::getDefaultFont()
{
  return SkFont();
}
