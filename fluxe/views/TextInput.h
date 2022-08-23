#pragma once

#include <regex>
#include "View.h"
#include "Text.h"
#include "../events/PressEvent.h"
#include "../layout/Padding.h"
#include "../../shell/timer.h"

namespace fluxe {

struct TextSelectionRange
{
    int start = 0;
    int end = 0;
};

class TextInput : public View, public IPressEventListener
{
  struct CaretPosition
  {
    float x = 0.0;
    float y = 0.0;
  };

public:

  const static std::regex NEW_LINE_REGEX;
//    = std::regex("\n");
//   ~/win/i.match(Sys.systemName()) ? ~/\r\n/i : ~/\n/i;

  TextInput();

  void setValue(std::string value);
  std::string getValue();

  std::function<void (std::string)> onValueChanged = [] (std::string value) {};
  Padding padding = {
    .left = 10,
    .right = 10,
    .top = 7,
    .bottom = 7,
  };

  virtual void measureLayout(LayoutConstraint constraints, PossibleLayoutSize parentSize) override;
  virtual void build(ObjectPointer<ViewBuilder> builder) override;


  void onPressStarted(PressStartedEvent event) override;
  void onPressFinished(PressFinishedEvent event) override;
  void onPressCanceled(PressCanceledEvent event) override;

  bool isFocusable() override;
  void didGainFocus() override;
  void didLoseFocus() override;

  void onTextInput(std::string text) override;
  void onKeyboardMoveAction(ShellKeyboardMoveInstruction event) override;

  void startCaretBlink();
  void stopCaretBlink();

private:
  ObjectPointer<Text> text;
  std::string value;
  std::vector<TextBox> selectionRects;
  TextSelectionRange selectionRange;
  CaretPosition caretPosition;
  Timer * caretTimer = nullptr;
  bool isHiddenCharacters = false;
  float caretHeight = 0.0;
  bool isFocused = false;
  bool isShowingCaret = false;
  bool needsCaretUpdate = false;

};

}
