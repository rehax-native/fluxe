#pragma once

#include "View.h"
#include "../events/PressEvent.h"
#include "../layout/Padding.h"
#include "./Text.h"

namespace fluxe {

struct SelectOption {
  std::string name;
  std::string value;
};

class Select : public View, public IPressEventListener
{
public:
  Padding textPadding = {
    .left = 10,
    .right = 10,
    .top = 5,
    .bottom = 5,
  };

  Select();

  void setOptions(std::vector<SelectOption> options);
  std::vector<SelectOption> getOptions();

  void setValue(Nullable<std::string> value);
  Nullable<std::string> getValue();

  void measureLayout(LayoutConstraint constraints, PossibleLayoutSize parentSize) override;
  void build(ObjectPointer<ViewBuilder> builder) override;

  void onPressStarted(PressStartedEvent & event) override;
  void onPressFinished(PressFinishedEvent & event) override;
  void onPressCanceled(PressCanceledEvent & event) override;

private:
  std::vector<SelectOption> options;
  ObjectPointer<Text> title;
  Nullable<std::string> value;
};

}
