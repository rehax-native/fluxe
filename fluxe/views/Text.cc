#include "Text.h"
#include <locale>
#include <codecvt>

using namespace fluxe;

Text::Text()
{}

void Text::setText(std::string text)
{
  this->text = text;
  setNeedsRerender(true);
  needsLayout = true;
}

void Text::setTextColor(Color color)
{
  textColor = color;
  setNeedsRerender(true);
}

void Text::setTextSize(float size)
{
  textSize = size;
  needsLayout = true;
  setNeedsRerender(true);
}

void Text::setFontFamilies(std::vector<std::string> fontFamilies)
{
  this->fontFamilies = fontFamilies;
  needsLayout = true;
  setNeedsRerender(true);
}

std::vector<TextBox> Text::getRectsForRange(int start, int end)
{
  if (needsLayout) {
    buildAndMeasureText();
    needsLayout = false;
  }
  auto rects = paragraph->getRectsForRange(start, end, skia::textlayout::RectHeightStyle::kTight, skia::textlayout::RectWidthStyle::kTight);
  return rects;
}

void Text::buildAndMeasureText()
{
  TextStyle textStyle;
  sk_sp<FontCollection> fontCollection = sk_make_sp<FontCollection>();

  fontCollection->setDefaultFontManager(SkFontMgr::RefDefault());

  textStyle.setColor(textColor.color);
  textStyle.setFontSize(textSize);

  if (fontFamilies.size() > 0) {
    std::vector<SkString> vector;
    for (auto & familiy : fontFamilies) {
      vector.push_back(SkString(familiy));
    }
    textStyle.setFontFamilies(vector);
  }

  ParagraphStyle paragraphStyle;
  paragraphStyle.setTextStyle(textStyle);
  ParagraphBuilderImpl builder(paragraphStyle, fontCollection);

  std::wstring_convert<std::codecvt_utf8_utf16<char16_t>,char16_t> convert;
  builder.addText(convert.from_bytes(text));

  paragraph = builder.Build();
  paragraph->layout(300);
  auto height = paragraph->getHeight();
  auto width = paragraph->getLongestLine();

  layoutSize = Nullable<LayoutSize>({
    .width = width,
    .height = height,
  });
}

void Text::measureLayout(LayoutConstraint constraints, PossibleLayoutSize parentSize)
{
  if (needsLayout || !layoutSize.isSet) {
    buildAndMeasureText();
    needsLayout = false;
  }
}

void Text::build(ObjectPointer<ViewBuilder> builder)
{
  View::build(builder);
  // var paint = new Paint();
  // paint.setColor(new Color(0xFFFFFFFF));
  // var typeface = Typeface.MakeDefault();
  // var font = Font.Create(typeface, 12);
  // var blob = TextBlob.MakeFromString(this.text, font);

  // builder.canvas.drawTextBlob(blob, 0, 15, paint);
  paragraph->paint(builder->getCanvas(), 0, 0);
}
