#include "Select.h"
#include "ViewManager.h"
#include "ContextMenu.h"

using namespace fluxe;

class SelectContextMenu : public ContextMenu
{
public:
  SelectContextMenu(ObjectPointer<Select> select)
  :select(select)
  {
    auto options = select->getOptions();
    for (auto option : options) {
      addItem(option.name, [this, option] () {
        this->select->setValue(option.value);
        this->select->getViewManager()->closeContextMenu();
      });
    }
  }

  ObjectPointer<Select> select;
};

Select::Select()
:title(Object<Text>::Create())
{
  addSubView(title);
  addEventListener<PressDetector>(this);
}

std::string Select::description()
{
  return "Select";
}

void Select::setOptions(std::vector<SelectOption> options)
{
  this->options = options;
}

std::vector<SelectOption> Select::getOptions() {
  return options;
}

void Select::setValue(Nullable<std::string> value) {
  this->value = value;
  Nullable<SelectOption> newValue;
  if (value.isSet) {
    for (auto option : options) {
      if (option.value == value.value) {
        newValue = option;
        break;
      }
    }
  }
  if (newValue.isSet) {
    title->setText(newValue.value.name);
  } else {
    title->setText("");
  }
  onValueChanged(newValue);
  setNeedsRerender(true);
}

Nullable<std::string> Select::getValue() {
  return value;
}

void Select::measureLayout(LayoutConstraint constraints, PossibleLayoutSize parentSize)
{
  title->measureLayout(constraints, parentSize);
  auto minWidth = 100.0;
  auto width = title->layoutSize.value.width + textPadding.left + textPadding.right;
  if (width < minWidth) {
    width = minWidth;
  }

  if (layoutSizeOverride.isSet) {
    if (auto p = std::get_if<SizeDimensionTypes::Fixed>(&layoutSizeOverride.value.width)) {
      width = p->size;
    } else if (auto p = std::get_if<SizeDimensionTypes::Percentage>(&layoutSizeOverride.value.width)) {
      if (parentSize.width.isSet) {
        width = parentSize.width.value * p->percent / 100.0;
      }
    } else if (auto p = std::get_if<SizeDimensionTypes::Fill>(&layoutSizeOverride.value.width)) {
      if (parentSize.width.isSet) {
        width = parentSize.width.value;
      }
    }
  }
  layoutSize = Nullable<LayoutSize>({
    .width = width + padding.left + padding.right,
    .height = title->layoutSize.value.height + textPadding.top + textPadding.bottom + padding.top + padding.bottom,
  });
  title->layoutPosition = Nullable<LayoutPosition>({
    .left = textPadding.left + padding.left,
    .top =  textPadding.top + padding.top,
  });

}

void Select::build(ObjectPointer<ViewBuilder> builder)
{
  View::build(builder);

  auto rrect = RRect::MakeRectXY(Rect::MakeXYWH(0, 0, layoutSize.value.width, layoutSize.value.height), 3, 3);

  Paint paint;
  paint.setAntiAlias(true);
  paint.setColor(Color::RGBA(0.6, 0.6, 0.6, 0.8).color);
  paint.setStyle(Paint::Style::kStroke_Style);
  builder->getCanvas()->drawRRect(rrect, paint);

  // if (state == ButtonState::Up) {
  //   paint.setColor(Color::RGBA(0.5, 0.5, 0.5, 0.2).color);
  // } else if (state == ButtonState::Down) {
  //   paint.setColor(Color::RGBA(0.0, 0.0, 0.0, 0.2).color);
  // // } else if (this.state == ButtonState.Hover) {
  // //     paint.setColor(Color.RGBA(0.8, 0.8, 0.8, 0.8));
  // // } else if (this.state == ButtonState.Disabled) {
  // //     paint.setColor(Color.RGBA(0.6, 0.6, 0.6, 0.8));
  // }

  // paint.setStyle(Paint::Style::kFill_Style);
  // builder->getCanvas()->drawRRect(rrect, paint);
}

void Select::onPressStarted(PressStartedEvent & event)
{
  // getViewManager()->getFocusManager().loseFocus();
  // state = ButtonState::Down;
  // setNeedsRerender(true);
}

void Select::onPressFinished(PressFinishedEvent & event)
{
  getViewManager()->getFocusManager().gainFocus(getThisPointer());
  if (event.button == 0) {
    auto menu = Object<SelectContextMenu>::Create(dynamic_pointer_cast<Select>(getThisPointer()));
    menu->setPosition({
      .left = PositionDimensionTypes::Fixed{event.left},
      .top = PositionDimensionTypes::Fixed{event.top},
    });

    getViewManager()->showContextMenu(menu);
  }
  event.stopPropagation();
}

void Select::onPressCanceled(PressCanceledEvent & event)
{
  // state = ButtonState::Up;
  // setNeedsRerender(true);
}
