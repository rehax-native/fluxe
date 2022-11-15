#include "fluxe/views/View.h"
#include "fluxe/views/Text.h"
#include "fluxe/views/Button.h"
#include "fluxe/views/Select.h"
#include "fluxe/views/TextInput.h"
#include "fluxe/layout/StackLayout.h"
#include "fluxe/views/EngineUtility.h"

#include <iostream>

using namespace fluxe;

//#if _WIN32
//#include <windows.h>

//int WINAPI WinMain(HINSTANCE inst, HINSTANCE prev, LPSTR cmd, int show) {
//#else
int main() {
//#endif

  auto text = Object<Text>::Create();
  text->setText("Hello World 😅");

  auto button = Object<Button>::Create();
  button->getTitle()->setText("Click Me");
  button->onClick = [&text] (ObjectPointer<Button> btn) {
    std::cout << "Clicked" << std::endl;
    text->removeFromParent();
  };

  auto textInput = Object<TextInput>::Create();

  auto container = Object<View>::Create();
  auto layout = Object<StackLayout>::Create();
  layout->spacing = 10.0;
  container->setLayout(layout);
  container->addSubView(text);
  // container->setBackgroundColor(Color::RGBA(1.0, 0, 0, 0.5));
  container->addSubView(button);
  container->addSubView(textInput);

  auto select = Object<Select>::Create();
  select->setOptions({
    SelectOption { .name = "Value 1", .value = "val1" },
    SelectOption { .name = "Value 2", .value = "val2" },
  });
  container->addSubView(select);

  auto richText = Object<Text>::Create();
  richText->setText({
    { .text = "EDA" },
    { .text = "?? ", .isUnderlined = true },
    { .text = "red", .color = Color::RGBA(1.0, 0, 0, 0.5), .fontSize = 20, .isItalic = true },
    { .text = " wrong", .fontFamilies = { "Courier New" }, .isStrikedThrough = true},
  });
  richText->setPadding({
    .left = 30,
    .top = 40,
  });

  container->addSubView(richText);

  EngineUtility::startWithView(container);

  return 0;
}
