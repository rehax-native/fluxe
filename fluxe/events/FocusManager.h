#pragma once

#include <rehaxUtils/pointers/Object.h>

using namespace rehaxUtils;

namespace fluxe {

class View;

class FocusManager
{
public:
    WeakObjectPointer<View> getCurrentFocusable();
    void gainFocus(ObjectPointer<View> view);
    void loseFocus();
    void focusNext();
    void focusPrevious();

private:
    WeakObjectPointer<View> currentFocusable;
};

}
