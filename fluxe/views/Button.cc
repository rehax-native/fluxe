#include "Button.h"
#include "../events/PressEvent.h"
#include "../events/FocusManager.h"
#include "ViewManager.h"

using namespace fluxe;

Button::Button()
:title(Object<Text>::Create())
{
  addSubView(title);
  addEventListener<PressDetector>(this);
}

ObjectPointer<Text> Button::getTitle()
{
  return title;
}

void Button::measureLayout(LayoutConstraint constraints, PossibleLayoutSize parentSize)
{
  title->measureLayout(constraints, parentSize);
  layoutSize = Nullable<LayoutSize>({
    .width = title->layoutSize.value.width + padding.left + padding.right,
    .height = title->layoutSize.value.height + padding.top + padding.bottom,
  });
  title->layoutPosition = Nullable<LayoutPosition>({
    .left = padding.left,
    .top = padding.top,
  });
}

void Button::build(ObjectPointer<ViewBuilder> builder)
{
    View::build(builder);

    auto rrect = RRect::MakeRectXY(Rect::MakeXYWH(0, 0, layoutSize.value.width, layoutSize.value.height), 3, 3);

    Paint paint;
    paint.setAntiAlias(true);
    paint.setColor(Color::RGBA(0.6, 0.6, 0.6, 0.8).color);
    paint.setStyle(Paint::Style::kStroke_Style);
    builder->getCanvas()->drawRRect(rrect, paint);

    if (state == ButtonState::Up) {
        paint.setColor(Color::RGBA(0.5, 0.5, 0.5, 0.2).color);
    } else if (state == ButtonState::Down) {
        paint.setColor(Color::RGBA(0.0, 0.0, 0.0, 0.2).color);
    // } else if (this.state == ButtonState.Hover) {
    //     paint.setColor(Color.RGBA(0.8, 0.8, 0.8, 0.8));
    // } else if (this.state == ButtonState.Disabled) {
    //     paint.setColor(Color.RGBA(0.6, 0.6, 0.6, 0.8));
    }

    paint.setStyle(Paint::Style::kFill_Style);
    builder->getCanvas()->drawRRect(rrect, paint);
}

void Button::onPressStarted(PressStartedEvent event)
{
  getViewManager()->getFocusManager().loseFocus();
  state = ButtonState::Down;
  setNeedsRerender(true);
}

void Button::onPressFinished(PressFinishedEvent event)
{
  state = ButtonState::Up;
  setNeedsRerender(true);

  auto thisPtr = getThisPointer();
  onClick(dynamic_pointer_cast<Button>(thisPtr));
}

void Button::onPressCanceled(PressCanceledEvent event)
{
  state = ButtonState::Up;
  setNeedsRerender(true);
}
