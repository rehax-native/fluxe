#include "ContextMenu.h"
#include "../layout/FlexLayout.h"
#include <rehaxUtils/app/app.h>

using namespace fluxe;

ContextMenuItem::ContextMenuItem() {
  textView = Object<Text>::Create();
  textView->setPadding({
    .left = 10,
    .right = 10,
    .top = 7,
    .bottom = 7,
  });
  addSubView(textView);
  addEventListener<PressDetector>(this);
}

void ContextMenuItem::setText(std::string text) {
  textView->setText(text);
}

void ContextMenuItem::setPressHandler(std::function<void(void)> handler) {
  pressHandler = handler;
}

void ContextMenuItem::onPressStarted(PressStartedEvent & event) {
  if (rehaxUtils::App::getApplicationTheme() == rehaxUtils::App::ApplicationTheme::SystemDark) {
    setBackgroundColor(::fluxe::Color::RGBA(1, 1, 1, 0.1));
  } else {
    setBackgroundColor(::fluxe::Color::RGBA(0, 0, 0, 0.1));
  }
}

void ContextMenuItem::onPressFinished(PressFinishedEvent & event) {
  pressHandler();
  setBackgroundColor(::fluxe::Color::RGBA(0, 0, 0, 0));
}

void ContextMenuItem::onPressCanceled(PressCanceledEvent & event) {
  setBackgroundColor(::fluxe::Color::RGBA(0, 0, 0, 0));
}

ContextMenu::ContextMenu() {
  if (rehaxUtils::App::getApplicationTheme() == rehaxUtils::App::ApplicationTheme::SystemDark) {
    setBackgroundColor(::fluxe::Color::RGBA(0.136, 0.136, 0.136, 1.0));
    setBorderColor(Color::RGBA(0.6, 0.6, 0.6, 0.8));
  } else {
    setBackgroundColor(::fluxe::Color::RGBA(0.936, 0.936, 0.936, 1.0));
    setBorderColor(Color::RGBA(0.6, 0.6, 0.6, 0.8));
  }
  setBorderWidth(1);
  setBorderRadius(BorderRadius {
    .topLeft = 7,
    .topRight = 7,
    .bottomLeft = 7,
    .bottomRight = 7,
  });
  auto layout = Object<FlexLayout>::Create();
  layout->direction = FlexDirection::Column;
  layout->alignItems = FlexAlignItems::Stretch;
  // layout->spacing = 10.0;
  setLayout(layout);
  setSize({
    .width = SizeDimensionTypes::Fixed { 150 }
  });
  }

  void ContextMenu::addItem(std::string title, std::function<void(void)> pressHandler) {
  auto item = Object<ContextMenuItem>::Create();
  item->setText(title);
  item->setPressHandler(pressHandler);
  addSubView(item);
}
