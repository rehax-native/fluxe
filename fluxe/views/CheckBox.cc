#include "CheckBox.h"
#include "../events/PressEvent.h"
#include "../events/FocusManager.h"
#include "ViewManager.h"

using namespace fluxe;

float CheckBox::BoxSize = 16;

CheckBox::CheckBox()
// :title(Object<Text>::Create())
{
  // addSubView(title);
  addEventListener<PressDetector>(this);
}

std::string CheckBox::description()
{
  return "CheckBox";
}

// ObjectPointer<Text> CheckBox::getTitle()
// {
//   return title;
// }

void CheckBox::measureLayout(LayoutConstraint constraints, PossibleLayoutSize parentSize)
{
  // title->measureLayout(constraints, parentSize);
  // layoutSize = Nullable<LayoutSize>({
  //   .width = title->layoutSize.value.width + textPadding.left + textPadding.right + padding.left + padding.right + BoxSize,
  //   .height = title->layoutSize.value.height + textPadding.top + textPadding.bottom + padding.top + padding.bottom,
  // });
  // title->layoutPosition = Nullable<LayoutPosition>({
  //   .left = BoxSize + textPadding.left + padding.left,
  //   .top = textPadding.top + padding.top,
  // });
  layoutSize = Nullable<LayoutSize>({
    .width = BoxSize,
    .height = BoxSize,
  });
}

void CheckBox::build(ObjectPointer<ViewBuilder> builder)
{
  View::build(builder);

  auto rrect = RRect::MakeRectXY(Rect::MakeXYWH(0, 0, BoxSize, BoxSize), 3, 3);

  Paint paint;
  paint.setAntiAlias(true);
  paint.setColor(Color::RGBA(0.6, 0.6, 0.6, 0.8).color);
  paint.setStyle(Paint::Style::kStroke_Style);
  builder->getCanvas()->drawRRect(rrect, paint);

//  if (state == CheckBoxState::On) {
//    paint.setColor(Color::RGBA(0.5, 0.5, 0.5, 0.2).color);
//  } else if (state == CheckBoxState::Off) {
//    paint.setColor(Color::RGBA(0.0, 0.0, 0.0, 0.2).color);
//  }

  paint.setColor(Color::RGBA(0.0, 0.0, 0.0, 0.2).color);
  paint.setStyle(Paint::Style::kFill_Style);
  builder->getCanvas()->drawRRect(rrect, paint);

  if (state == CheckBoxState::On) {
    paint.setColor(Color::RGBA(1, 1, 1, 1).color);
    paint.setStyle(Paint::Style::kStroke_Style);
    paint.setStrokeWidth(2);
    paint.setStrokeCap(SkPaint::kRound_Cap);
    auto checkmarkPadding = 0.25 * BoxSize;
    float xPos = 0.4;
    builder->getCanvas()->drawLine(checkmarkPadding, BoxSize * 0.6, BoxSize * xPos, BoxSize - checkmarkPadding, paint);
    builder->getCanvas()->drawLine(BoxSize * xPos, BoxSize - checkmarkPadding, BoxSize - checkmarkPadding, checkmarkPadding, paint);
  }
}

void CheckBox::setValue(bool value) {
  state = value ? CheckBoxState::On : CheckBoxState::Off;
}

bool CheckBox::getValue() {
  return state == CheckBoxState::On;
}

void CheckBox::onPressStarted(PressStartedEvent & event)
{
  getViewManager()->getFocusManager().loseFocus();
}

void CheckBox::onPressFinished(PressFinishedEvent & event)
{
  state = state == CheckBoxState::On ? CheckBoxState::Off : CheckBoxState::On;
  setNeedsRerender(true);

  auto thisPtr = getThisPointer();
  onToggle(dynamic_pointer_cast<CheckBox>(thisPtr));
}

void CheckBox::onPressCanceled(PressCanceledEvent & event)
{
  setNeedsRerender(true);
}
