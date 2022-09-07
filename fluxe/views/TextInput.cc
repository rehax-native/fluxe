#include "TextInput.h"
#include "ViewManager.h"
#include "../layout/FlexLayout.h"
#include "../../shell/clipboard.h"

using namespace fluxe;

const std::regex TextInput::NEW_LINE_REGEX = std::regex("\n");

class ContextMenuItem : public View, public IPressEventListener
{
public:
  ContextMenuItem()
  {
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

  void setText(std::string text)
  {
    textView->setText(text);
  }

  void setPressHandler(std::function<void(void)> handler)
  {
    pressHandler = handler;
  }

  void onPressStarted(PressStartedEvent & event) override
  {
    setBackgroundColor(::fluxe::Color::RGBA(1, 1, 1, 0.1));
  }

  void onPressFinished(PressFinishedEvent & event) override
  {
    pressHandler();
    setBackgroundColor(::fluxe::Color::RGBA(0, 0, 0, 0));
  }

  void onPressCanceled(PressCanceledEvent & event) override
  {
    setBackgroundColor(::fluxe::Color::RGBA(0, 0, 0, 0));
  }

private:
  ObjectPointer<Text> textView;
  std::function<void(void)> pressHandler;
};

class ContextMenu : public View
{
public:
  ContextMenu()
  {
    setBackgroundColor(::fluxe::Color::RGBA(0.136, 0.136, 0.136, 1.0));
    setBorderColor(Color::RGBA(0.6, 0.6, 0.6, 0.8));
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

  void addItem(std::string title, std::function<void(void)> pressHandler)
  {
    auto item = Object<ContextMenuItem>::Create();
    item->setText(title);
    item->setPressHandler(pressHandler);
    addSubView(item);
  }
};

class TextInputContextMenu : public ContextMenu
{
public:
  TextInputContextMenu(ObjectPointer<TextInput> textInput)
  :textInput(textInput)
  {
    addItem("Copy", [this] () {
      this->textInput->copyTextToClipboard();
      this->textInput->getViewManager()->closeContextMenu();
    });
    addItem("Cut", [this] () {
      this->textInput->cutTextToClipboard();
      this->textInput->getViewManager()->closeContextMenu();
    });
    addItem("Paste", [this] () {
      this->textInput->pasteTextFromClipboard();
      this->textInput->getViewManager()->closeContextMenu();
    });
  }

  ObjectPointer<TextInput> textInput;
};

TextInput::TextInput()
:text(Object<Text>::Create())
{
  addSubView(text);
  addEventListener<PressDetector>(this);
  setBorderColor(Color::RGBA(0.6, 0.6, 0.6, 0.8));
  setBorderWidth(1);
  setBorderRadius(BorderRadius {
    .topLeft = 3,
    .topRight = 3,
    .bottomLeft = 3,
    .bottomRight = 3,
  });
}

void TextInput::setValue(std::string value)
{
  if (this->value != value)
  {
    this->value = value;
    if (isHiddenCharacters) {
      std::string hiddenText = "";
      for (int i = 0; i < value.length(); i++) {
        hiddenText += "•";
      }
      text->setText(hiddenText);
    } else {
      text->setText(value);
    }
    onValueChanged(value);
  }
}

std::string TextInput::getValue()
{
  return value;
}

void TextInput::measureLayout(LayoutConstraint constraints, PossibleLayoutSize parentSize)
{
  text->measureLayout(constraints, parentSize);
  auto minWidth = 100.0;
  auto width = text->layoutSize.value.width + textPadding.left + textPadding.right;
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
    .height = text->layoutSize.value.height + textPadding.top + textPadding.bottom + padding.top + padding.bottom,
  });
  if (caretHeight < 1.0) {
    caretHeight = text->layoutSize.value.height;
  }
  text->layoutPosition = Nullable<LayoutPosition>({
    .left = textPadding.left + padding.left,
    .top =  textPadding.top + padding.top,
  });
}

void TextInput::build(ObjectPointer<ViewBuilder> builder)
{
  View::build(builder);

  auto rrect = RRect::MakeRectXY(Rect::MakeXYWH(0, 0, layoutSize.value.width, layoutSize.value.height), 3, 3);

  Paint paint;
  paint.setAntiAlias(true);
  paint.setStyle(Paint::Style::kStroke_Style);

  if (isFocused) {
    paint.setColor(Color::RGBA(0.6, 0.8, 1.0, 0.8).color);
    paint.setStrokeWidth(2);
    auto rrect = RRect::MakeRectXY(Rect::MakeXYWH(1, 1, layoutSize.value.width - 2, layoutSize.value.height - 2), 3, 3);
    builder->getCanvas()->drawRRect(rrect, paint);
    paint.setStrokeWidth(1);
  //     paint.setColor(Color.RGBA(0.2, 0.2, 0.2, 0.6));
  // } else {
  //     paint.setColor(Color.RGBA(0.2, 0.2, 0.2, 0.2));
  // // } else if (this.state == ButtonState.Hover) {
  // //     paint.setColor(Color.RGBA(0.8, 0.8, 0.8, 0.8));
  // // } else if (this.state == ButtonState.Disabled) {
  // //     paint.setColor(Color.RGBA(0.6, 0.6, 0.6, 0.8));
  }

  paint.setStyle(Paint::Style::kFill_Style);
  paint.setColor(Color::RGBA(1.0, 1.0, 1.0, 0.3).color);

  if (needsCaretUpdate) {
    bool hasSelection = selectionRange.start != selectionRange.end;
    bool isSelectionReverse = selectionRange.start > selectionRange.end;

    int rangeStart = 0;
    if (hasSelection) {
      rangeStart = isSelectionReverse ? selectionRange.end : selectionRange.start;
    }
    int rangeEnd = isSelectionReverse ? selectionRange.start : selectionRange.end;

    auto rects = text->getRectsForRange(rangeStart, rangeEnd);
    if (rects.size() > 0) {
      auto caretRect = rects[rects.size() - 1];
      if (isSelectionReverse) {
        caretRect = rects[0];
      }

      caretPosition = {
        .x = isSelectionReverse ? caretRect.rect.left() : caretRect.rect.right(),
        .y = caretRect.rect.top(),
      };
      caretHeight = caretRect.rect.bottom() - caretRect.rect.top();
    } else {
      caretPosition = {
        .x = 0.0,
        .y = 0.0,
      };
    }
    if (hasSelection) {
      selectionRects = rects;
    } else {
      selectionRects = {};
    }

    needsCaretUpdate = false;
  }

  for (auto rect : selectionRects) {
    auto selRect = Rect::MakeXYWH(
      text->layoutPosition.value.left + rect.rect.left(),
      text->layoutPosition.value.top + rect.rect.top(),
      rect.rect.right() - rect.rect.left(),
      rect.rect.bottom() - rect.rect.top()
    );
    builder->getCanvas()->drawRect(selRect, paint);
  }

  if (isShowingCaret) {
    auto caretRect = Rect::MakeXYWH(text->layoutPosition.value.left + caretPosition.x, text->layoutPosition.value.top + caretPosition.y, 1, caretHeight);
    paint.setStyle(Paint::Style::kFill_Style);
    paint.setColor(Color::RGBA(1.0, 1.0, 1.0, 1.0).color);
    builder->getCanvas()->drawRect(caretRect, paint);
  }
}

void TextInput::focus() {
  getViewManager()->getFocusManager().gainFocus(getThisPointer());
}

void TextInput::blur() {
  // should probably be moved to focus manager
  if (getViewManager()->getFocusManager().getCurrentFocusable().get() == this) {
    getViewManager()->getFocusManager().loseFocus();
  }
}

void TextInput::onPressStarted(PressStartedEvent & event)
{}

void TextInput::onPressFinished(PressFinishedEvent & event)
{
  getViewManager()->getFocusManager().gainFocus(getThisPointer());
  if (event.button == 1) {

    auto menu = Object<TextInputContextMenu>::Create(dynamic_pointer_cast<TextInput>(getThisPointer()));
    menu->setPosition({
      .left = PositionDimensionTypes::Fixed{event.left},
      .top = PositionDimensionTypes::Fixed{event.top},
    });

    getViewManager()->showContextMenu(menu);
  }
  event.stopPropagation();
}

void TextInput::onPressCanceled(PressCanceledEvent & event)
{}

bool TextInput::isFocusable()
{
  return true;
}

void TextInput::didGainFocus()
{
  isFocused = true;
  startCaretBlink();
  onFocus();
}

void TextInput::didLoseFocus()
{
  isFocused = false;
  stopCaretBlink();
  onBlur();
}

void TextInput::onTextInput(std::string text)
{
  auto isSelectionReverse = selectionRange.start > selectionRange.end;
  auto rangeStart = isSelectionReverse ? selectionRange.end : selectionRange.start;
  auto rangeEnd = isSelectionReverse ? selectionRange.start : selectionRange.end;

  setValue(value.substr(0, rangeStart) + text + value.substr(rangeEnd));
  setNeedsRerender(true);
  needsCaretUpdate = true;
  selectionRange.end = rangeStart + text.size();
  selectionRange.start = selectionRange.end;
  startCaretBlink();
}

void TextInput::onKeyboardMoveAction(ShellKeyboardMoveInstruction event)
{
  if (event.isTab && event.isForwards) {
    getViewManager()->getFocusManager().focusNext();
    return;
  } else if (event.isTab && event.isBackwards) {
    getViewManager()->getFocusManager().focusPrevious();
    return;
  }

  auto newRangeStart = selectionRange.start;
  auto newRangeEnd = selectionRange.end;
  auto hadSelectionBefore = selectionRange.start != selectionRange.end;

  if (!(hadSelectionBefore && event.isDelete)) {
    if (event.isAll || event.isDocument) {
      if (event.isSelect) {
        newRangeStart = 0;
        newRangeEnd = value.size();
      } else if (event.isBackwards || event.isLeft || event.isUp) {
        newRangeStart = 0;
        newRangeEnd = 0;
      } else if (event.isForwards || event.isRight || event.isDown) {
        newRangeStart = value.size();
        newRangeEnd = value.size();
      }
    } else if (event.isPage) {
    } else if (event.isParagraph) {
    } else if (event.isLine) {
      auto i = selectionRange.end;
      auto r = NEW_LINE_REGEX;
      if (event.isLeft || event.isBackwards) {
        i = selectionRange.end - 1;
        while (i > 0) {
          if (std::regex_search(value.substr(i, 1), r)) {
            break;
          }
          i--;
        }
        if (i < 0) {
          i = 0;
        }
      } else if (event.isRight || event.isForwards) {
        i = selectionRange.end + 1;
        while (i < value.size()) {
          if (std::regex_search(value.substr(i, 1), r)) {
            break;
          }
          i++;
        }
        if (i > value.size()) {
          i = value.size();
        }
      }
      newRangeEnd = i;
    } else if (event.isWord) {
      auto i = selectionRange.end;
      auto foundChar = false;
      std::regex wordRegex("(\\w)");
      if (event.isLeft || event.isBackwards) {
        i = selectionRange.end - 1;
        while (i > 0) {
          if (std::regex_search(value.substr(i, 1), wordRegex)) {
            foundChar = true;
          } else if (foundChar) {
            i += 1;
            break;
          }
          i--;
        }
        if (i < 0) {
          i = 0;
        }
      } else if (event.isRight || event.isForwards) {
        i = selectionRange.end + 1;
        while (i < value.size()) {
          if (std::regex_search(value.substr(i, 1), wordRegex)) {
            foundChar = true;
          } else if (foundChar) {
            break;
          }
          i++;
        }
        if (i > value.size()) {
          i = value.size();
        }
      }
      newRangeEnd = i;
    } else {
      if (event.isLeft || event.isBackwards) {
        newRangeEnd = selectionRange.end - 1;
        if (newRangeEnd < 0) {
          newRangeEnd = 0;
        }
      } else if (event.isRight || event.isForwards) {
        newRangeEnd = selectionRange.end + 1;
        if (newRangeEnd > value.size()) {
          newRangeEnd = value.size();
        }
      }
    }
  }

  if (event.isDelete) {
    auto strDeleteStart = newRangeStart;
    auto strDeleteEnd = newRangeEnd;
    if (strDeleteStart > strDeleteEnd) {
      auto tmp = strDeleteStart;
      strDeleteStart = strDeleteEnd;
      strDeleteEnd = tmp;
    }

    auto isForward = newRangeStart < newRangeEnd;

    setValue(value.substr(0, strDeleteStart) + value.substr(strDeleteEnd));

    if (isForward) {
      newRangeEnd = newRangeStart;
    } else {
      newRangeStart = newRangeEnd;
    }
  } else if (!event.isSelect) {
    newRangeStart = newRangeEnd;
  }


  selectionRange.start = newRangeStart;
  selectionRange.end = newRangeEnd;

  if (selectionRange.start < 0) {
    selectionRange.start = 0;
  }
  if (selectionRange.start > value.size()) {
    selectionRange.start = value.size();
  }
  if (selectionRange.end < 0) {
    selectionRange.end = 0;
  }
  if (selectionRange.end > value.size()) {
    selectionRange.end = value.size();
  }

  setNeedsRerender(true);
  needsCaretUpdate = true;
  startCaretBlink();
}

bool TextInput::isHandlingKeyboardCommand(ShellKeyboardCommand command)
{
  if (
    command.isWithCmdCtrlModifier && (
      command.commandKey == "a" ||
      command.commandKey == "c" ||
      command.commandKey == "v" ||
      command.commandKey == "x"
    )
  ) {
    return true;
  }
  return false;
}

void TextInput::onKeyboardCommand(ShellKeyboardCommand command)
{
  if (!command.isWithCmdCtrlModifier) {
    return;
  }
  if (command.commandKey == "a") {
    onKeyboardMoveAction({
      .isAll = true,
      .isSelect = true,
    });
  } else if (command.commandKey == "c") {
    copyTextToClipboard();
  } else if (command.commandKey == "x") {
    cutTextToClipboard();
  } else if (command.commandKey == "v") {
    pasteTextFromClipboard();
  }
}

// void TextInput::onClipboardData(ShellClipboardData data)
// {
//   onTextInput(data.stringData);
// }

std::string TextInput::getSelectedText()
{
  auto start = selectionRange.start;
  auto end = selectionRange.end;
  if (start > end) {
    auto t = start;
    start = end;
    end = t;
  }
  return value.substr(start, end - start);
}

void TextInput::startCaretBlink()
{
  stopCaretBlink();

  isShowingCaret = true;
 if (caretTimer == nullptr) {
   caretTimer = Timer::startInterval(500, [this] () {
     isShowingCaret = !isShowingCaret;
     setNeedsRerender(true);
   });
 }
  setNeedsRerender(true);
}

void TextInput::stopCaretBlink()
{
  isShowingCaret = false;
  setNeedsRerender(true);
 if (caretTimer != nullptr) {
     Timer::stopTimer(caretTimer);
     caretTimer = nullptr;
 }
}

void TextInput::copyTextToClipboard()
{
  if (selectionRange.start != selectionRange.end && !isHiddenCharacters) {
    auto str = getSelectedText();
    Clipboard::copyStringToClipboard(str);
  }
}

void TextInput::cutTextToClipboard()
{
  if (selectionRange.start != selectionRange.end && !isHiddenCharacters) {
    auto str = getSelectedText();
    Clipboard::copyStringToClipboard(str);
    onTextInput("");
  }
}

void TextInput::pasteTextFromClipboard()
{
  auto str = Clipboard::pasteStringFromClipboard();
  onTextInput(str);
}
