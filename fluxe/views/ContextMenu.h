#pragma once

#include "View.h"
#include "../events/PressEvent.h"
#include "./Text.h"

namespace fluxe {

class ContextMenuItem : public View, public IPressEventListener
{
public:
  ContextMenuItem();
  void setText(std::string text);
  void setPressHandler(std::function<void(void)> handler);
  void onPressStarted(PressStartedEvent & event) override;
  void onPressFinished(PressFinishedEvent & event) override;
  void onPressCanceled(PressCanceledEvent & event) override;

private:
  ObjectPointer<Text> textView;
  std::function<void(void)> pressHandler;
};

class ContextMenu : public View
{
public:
  ContextMenu();
  void addItem(std::string title, std::function<void(void)> pressHandler);
};

}
