#include "fluxe/views/View.h"
#include "fluxe/views/Text.h"
#include "fluxe/views/Button.h"
#include "fluxe/views/TextInput.h"
#include "fluxe/layout/StackLayout.h"
#include "fluxe/layout/FlexLayout.h"
#include "fluxe/views/EngineUtility.h"

#include <iostream>

using namespace fluxe;

#if _WIN32
#include <windows.h>

int WINAPI WinMain(HINSTANCE inst, HINSTANCE prev, LPSTR cmd, int show) {
#else
int main() {
#endif

  bool isHorizontal = false;

  auto container = Object<View>::Create();
  bool enableFlexGrow = true;
  FlexJustifyContent flexJustify = FlexJustifyContent::FlexStart;
  FlexAlignItems alignItems = FlexAlignItems::FlexStart;
    
  auto layoutFlex = [&container, &isHorizontal, &enableFlexGrow, &flexJustify, &alignItems] () {
    auto layout = Object<FlexLayout>::Create();
    layout->justifyContent = flexJustify;
    layout->alignItems = alignItems;
    layout->direction = isHorizontal ? FlexDirection::Row : FlexDirection::Column;
    layout->itemInfos = {
      {}, // text
      { .flexGrow = enableFlexGrow ? 1.0 : Nullable<float>() }, // button container
      {}, // text
      { .flexGrow = enableFlexGrow ? 2.0 : Nullable<float>() }, // text input
    };
    container->setLayout(layout);
  };
    
  auto layout = Object<StackLayout>::Create();
  layout->spacing = 10.0;
  container->setLayout(layout);

  auto text = Object<Text>::Create();
  text->setText("Hello World");
  container->addSubView(text);

  auto buttonsContainer = Object<View>::Create();

  auto button = Object<Button>::Create();
  button->getTitle()->setText("Horizontal/Vertical Stack Layout");
  button->onClick = [&container, &isHorizontal] (ObjectPointer<Button> btn) {
    auto layout = Object<StackLayout>::Create();
    layout->spacing = 10.0;
    isHorizontal = !isHorizontal;
    layout->layoutDirection = isHorizontal ? StackLayoutDirection::Horizontal : StackLayoutDirection::Vertical;
    container->setLayout(layout);
  };
  buttonsContainer->addSubView(button);

  button = Object<Button>::Create();
  button->getTitle()->setText("Flex");
  button->onClick = [&isHorizontal, &layoutFlex] (ObjectPointer<Button> btn) {
    isHorizontal = !isHorizontal;
    layoutFlex();
  };
  buttonsContainer->addSubView(button);

  button = Object<Button>::Create();
  button->getTitle()->setText("Justify next option");
  button->onClick = [&flexJustify, &layoutFlex] (ObjectPointer<Button> btn) {
    switch (flexJustify) {
      case FlexJustifyContent::FlexStart:
        flexJustify = FlexJustifyContent::FlexEnd;
        break;
      case FlexJustifyContent::FlexEnd:
        flexJustify = FlexJustifyContent::Center;
        break;
      case FlexJustifyContent::Center:
        flexJustify = FlexJustifyContent::SpaceBetween;
        break;
      case FlexJustifyContent::SpaceBetween:
        flexJustify = FlexJustifyContent::SpaceAround;
        break;
      case FlexJustifyContent::SpaceAround:
        flexJustify = FlexJustifyContent::SpaceEvenly;
        break;
      case FlexJustifyContent::SpaceEvenly:
        flexJustify = FlexJustifyContent::FlexStart;
        break;
    }
    layoutFlex();
  };
  buttonsContainer->addSubView(button);

  button = Object<Button>::Create();
  button->getTitle()->setText("Align next option");
  button->onClick = [&alignItems, &layoutFlex] (ObjectPointer<Button> btn) {
    switch (alignItems) {
      case FlexAlignItems::FlexStart:
        alignItems = FlexAlignItems::FlexEnd;
        break;
      case FlexAlignItems::FlexEnd:
        alignItems = FlexAlignItems::Center;
        break;
      case FlexAlignItems::Center:
        alignItems = FlexAlignItems::Stretch;
        break;
      case FlexAlignItems::Stretch:
        alignItems = FlexAlignItems::FlexStart;
        break;
    }
    layoutFlex();
  };
  buttonsContainer->addSubView(button);

  button = Object<Button>::Create();
  button->getTitle()->setText("Toggle flex grow");
  button->onClick = [&enableFlexGrow, &layoutFlex] (ObjectPointer<Button> btn) {
    enableFlexGrow = !enableFlexGrow;
    layoutFlex();
  };
  buttonsContainer->addSubView(button);

  container->addSubView(buttonsContainer);

  text = Object<Text>::Create();
  text->setText("Fixed Size");
  text->setSize({
    .width = SizeDimensionTypes::Fixed { 50 },
    .height = SizeDimensionTypes::Fixed { 50 },
  });
  text->setBackgroundColor(Color::RGBA(1.0, 0.0, 0.0, 1.0));
  container->addSubView(text);

  auto textInput = Object<TextInput>::Create();
  container->addSubView(textInput);

  EngineUtility::startWithView(container);

  return 0;
}
