#include "TextInput.h"
#include "ViewManager.h"

using namespace fluxe;

const std::regex TextInput::NEW_LINE_REGEX = std::regex("\n");

TextInput::TextInput()
:text(Object<Text>::Create())
{
  addSubView(text);
  addEventListener<PressDetector>(this);
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
  auto width = text->layoutSize.value.width + padding.left + padding.right;
  if (width < minWidth) {
    width = minWidth;
  }
  layoutSize = Nullable<LayoutSize>({
    .width = width,
    .height = text->layoutSize.value.height + padding.top + padding.bottom,
  });
  if (caretHeight < 1.0) {
    caretHeight = text->layoutSize.value.height;
  }
  text->layoutPosition = Nullable<LayoutPosition>({
    .left = padding.left,
    .top =  padding.top,
  });
}

void TextInput::build(ObjectPointer<ViewBuilder> builder)
{
  View::build(builder);

  auto rrect = RRect::MakeRectXY(Rect::MakeXYWH(0, 0, layoutSize.value.width, layoutSize.value.height), 3, 3);

  Paint paint;
  paint.setAntiAlias(true);
  paint.setColor(Color::RGBA(0.6, 0.6, 0.6, 0.8).color);
  paint.setStyle(Paint::Style::kStroke_Style);
  builder->getCanvas()->drawRRect(rrect, paint);

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

void TextInput::onPressStarted(PressStartedEvent event)
{}

void TextInput::onPressFinished(PressFinishedEvent event)
{
  getViewManager()->getFocusManager().gainFocus(getThisPointer());
}

void TextInput::onPressCanceled(PressCanceledEvent event)
{}

bool TextInput::isFocusable()
{}

void TextInput::didGainFocus()
{
  isFocused = true;
  startCaretBlink();
}

void TextInput::didLoseFocus()
{
  isFocused = false;
  stopCaretBlink();
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
