#pragma once

#include "View.h"
#include "FontManager.h"

namespace fluxe {

struct TextPart {
  std::string text;
  Nullable<Color> color;
  Nullable<float> fontSize;
  std::vector<std::string> fontFamilies;
  bool isItalic = false;
  bool isUnderlined = false;
  bool isStrikedThrough = false;
};

class Text : public View
{
public:
  Text();

  void setText(std::string text);
  void setText(std::vector<TextPart> textParts);
  // void setTextColor(Color color);
  // void setTextSize(float size);
  // void setFontFamilies(std::vector<std::string> fontFamilies);

  std::string getText();
  std::vector<TextPart> getTextParts();
  // Color getTextColor();
  // float getTextSize();
  // std::vector<std::string> setFontFamilies();

  std::vector<TextBox> getRectsForRange(int start, int end);
  void buildAndMeasureText(LayoutConstraint constraints, PossibleLayoutSize parentSize);
  void measureLayout(LayoutConstraint constraints, PossibleLayoutSize parentSize) override;
  void build(ObjectPointer<ViewBuilder> builder) override;

private:
  // std::string text;
  std::vector<TextPart> textParts;
  bool needsLayout = true;
  std::unique_ptr<Paragraph> paragraph;
  Color textColor = Color::RGBA(1.0, 1.0, 1.0, 1.0);
  float textSize = 12;
  std::vector<std::string> fontFamilies;
};

}
