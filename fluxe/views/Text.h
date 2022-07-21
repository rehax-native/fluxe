#pragma once

#include "View.h"

namespace fluxe {

class Text : public View
{
public:
  Text();

  void setText(std::string text);
  void setTextColor(Color color);
  void setTextSize(float size);
  void setFontFamilies(std::vector<std::string> fontFamilies);

  std::vector<TextBox> getRectsForRange(int start, int end);
  void buildAndMeasureText();
  void measureLayout(LayoutConstraint constraints, PossibleLayoutSize parentSize) override;
  void build(ObjectPointer<ViewBuilder> builder) override;

private:
  std::string text;
  bool needsLayout = true;
  std::unique_ptr<Paragraph> paragraph;
  Color textColor;
  float textSize = 14;
  std::vector<std::string> fontFamilies;
};

}
