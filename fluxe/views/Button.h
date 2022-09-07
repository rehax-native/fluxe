#pragma once

#include "View.h"
#include "../events/PressEvent.h"
#include "../layout/Padding.h"
#include "./Text.h"

namespace fluxe {

enum class ButtonState
{
  Up,
  Down,
  Hover,
  Disabled,
};

class Button : public View, public IPressEventListener
{
protected:

    ObjectPointer<Text> title;
    Padding textPadding = {
        .left = 10,
        .right = 10,
        .top = 5,
        .bottom = 5,
    };
    
    ButtonState state = ButtonState::Up;

public:

    Button();
    ObjectPointer<Text> getTitle();
    std::function<void (ObjectPointer<Button>)> onClick = [] (ObjectPointer<Button> btn) {};

    void measureLayout(LayoutConstraint constraints, PossibleLayoutSize parentSize) override;
    void build(ObjectPointer<ViewBuilder> builder) override;

    void onPressStarted(PressStartedEvent & event) override;
    void onPressFinished(PressFinishedEvent & event) override;
    void onPressCanceled(PressCanceledEvent & event) override;
};

}
