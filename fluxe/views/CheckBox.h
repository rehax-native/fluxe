#pragma once

#include "View.h"
#include "../events/PressEvent.h"
#include "../layout/Padding.h"
#include "./Text.h"

namespace fluxe {

enum class CheckBoxState
{
  On,
  Off,
};

class CheckBox : public View, public IPressEventListener
{
protected:

    // ObjectPointer<Text> title;
    // Padding textPadding = {
    //     .left = 10,
    //     .right = 10,
    //     .top = 5,
    //     .bottom = 5,
    // };
    static float BoxSize;
    
    CheckBoxState state = CheckBoxState::Off;

public:

    CheckBox();
    // ObjectPointer<Text> getTitle();
    std::function<void (ObjectPointer<CheckBox>)> onToggle = [] (ObjectPointer<CheckBox> checkBox) {};

    void setValue(bool value);
    bool getValue();

    void measureLayout(LayoutConstraint constraints, PossibleLayoutSize parentSize) override;
    void build(ObjectPointer<ViewBuilder> builder) override;

    void onPressStarted(PressStartedEvent & event) override;
    void onPressFinished(PressFinishedEvent & event) override;
    void onPressCanceled(PressCanceledEvent & event) override;
};

}
