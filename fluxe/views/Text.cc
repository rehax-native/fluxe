#include "Text.h"
#include <locale>
#include <codecvt>

using namespace fluxe;

Text::Text()
{}

void Text::setText(std::string text)
{
  setText(std::vector<TextPart> {
    {
      .text = text,
    }
  });
}

void Text::setText(std::vector<TextPart> textParts)
{
  this->textParts = textParts;
  setNeedsRerender(true);
  needsLayout = true;
}

// void Text::setTextColor(Color color)
// {
//   textColor = color;
//   setNeedsRerender(true);
// }

// void Text::setTextSize(float size)
// {
//   textSize = size;
//   needsLayout = true;
//   setNeedsRerender(true);
// }

// void Text::setFontFamilies(std::vector<std::string> fontFamilies)
// {
//   this->fontFamilies = fontFamilies;
//   needsLayout = true;
//   setNeedsRerender(true);
// }

std::string Text::getText()
{
  std::string text = "";
  for (auto part : textParts) {
    text += part.text;
  }
  return text;
}

std::vector<TextPart> Text::getTextParts()
{
  return textParts;
}

// Color Text::getTextColor()
// {
//   return textColor;
// }

// float Text::getTextSize()
// {
//   return textSize;
// }

// std::vector<std::string> Text::setFontFamilies()
// {
//   return fontFamilies;
// }

std::vector<TextBox> Text::getRectsForRange(int start, int end)
{
  if (needsLayout) {
    buildAndMeasureText({}, {});
    needsLayout = false;
  }
  auto rects = paragraph->getRectsForRange(start, end, skia::textlayout::RectHeightStyle::kTight, skia::textlayout::RectWidthStyle::kTight);
  return rects;
}

void Text::buildAndMeasureText(LayoutConstraint constraints, PossibleLayoutSize parentSize)
{
  TextStyle textStyle;
  sk_sp<FontCollection> fontCollection = sk_make_sp<FontCollection>();

  fontCollection->setDefaultFontManager(SkFontMgr::RefDefault());

  textStyle.setColor(textColor.color);
  textStyle.setFontSize(textSize);

  ParagraphStyle paragraphStyle;
  paragraphStyle.setTextStyle(textStyle);
  ParagraphBuilderImpl builder(paragraphStyle, fontCollection);

  std::wstring_convert<std::codecvt_utf8_utf16<char16_t>,char16_t> convert;
  for (auto & part : textParts) {
    TextStyle partStyle(textStyle);

    if (part.fontFamilies.size() > 0) {
      std::vector<SkString> vector;
      for (auto & familiy : part.fontFamilies) {
        vector.push_back(SkString(familiy));
      }
      partStyle.setFontFamilies(vector);
    }

    if (part.color.isSet) {
      partStyle.setColor(part.color.value.color);
    }
    if (part.fontSize.isSet) {
      partStyle.setFontSize(part.fontSize.value);
    }
    SkFontStyle::Width width = SkFontStyle::kNormal_Width;
    SkFontStyle::Weight weight = SkFontStyle::kNormal_Weight;
    SkFontStyle::Slant slant = SkFontStyle::kUpright_Slant;
    if (part.isItalic) {
      slant = SkFontStyle::kItalic_Slant;
    }
    if (part.isUnderlined) {
      partStyle.setDecoration(skia::textlayout::kUnderline);
    }
    if (part.isStrikedThrough) {
      partStyle.setDecoration(skia::textlayout::kLineThrough);
    }
    partStyle.setFontStyle(SkFontStyle(weight, width, slant));
    builder.pushStyle(partStyle);
    builder.addText(convert.from_bytes(part.text));
    builder.pop();
  }

  float maxSize = 99999;
  if (parentSize.width.isSet) {
    maxSize = parentSize.width.value;
  } else if (constraints.maxWidth.isSet) {
    maxSize = constraints.maxWidth.value;
  }
  maxSize -= padding.left + padding.right;

  paragraph = builder.Build();
  paragraph->layout(maxSize);
  auto height = paragraph->getHeight();
  auto width = paragraph->getLongestLine();

  layoutSize = Nullable<LayoutSize>({
    .width = width + padding.left + padding.right,
    .height = height + padding.top + padding.bottom,
  });
}

void Text::measureLayout(LayoutConstraint constraints, PossibleLayoutSize parentSize)
{
  if (needsLayout || !layoutSize.isSet) {
    buildAndMeasureText(constraints, parentSize);
    needsLayout = false;
  }
  auto views = getSubViews();
  for (auto & subView : views) {
    subView->measureLayout(constraints, parentSize);
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
  paragraph->paint(builder->getCanvas(), padding.left, padding.top);
}
