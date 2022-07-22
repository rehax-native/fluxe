#pragma once

#include <set>
#include "MouseEvents.h"
#include "../../shell/callbacks.h"

namespace fluxe {

class IEventListener
{
public:
  virtual ~IEventListener() = default;
  virtual void onMouseDown(MouseDownEvent event);
  virtual void onMouseUp(MouseUpEvent event);
  virtual void onMouseMove(MouseMoveEvent event);
  virtual void onMouseEnter(MouseEnterEvent event);
  virtual void onMouseExit(MouseExitEvent event);

  virtual bool isFocusable();
  virtual void didGainFocus();
  virtual void didLoseFocus();

  virtual void onTextInput(std::string text);
  virtual void onKeyboardMoveAction(ShellKeyboardMoveInstruction event);

private:
};

class IEventListenerContainer : public IEventListener
{
public:
  virtual ~IEventListenerContainer();

  template <typename T, typename... Args>
  void addEventListener(Args&&... args)
  {
    eventListeners.insert(new T(std::forward<Args>(args)...));
  }

  void onMouseDown(MouseDownEvent event) override;
  void onMouseUp(MouseUpEvent event) override;
  void onMouseMove(MouseMoveEvent event) override;
  void onMouseEnter(MouseEnterEvent event) override;
  void onMouseExit(MouseExitEvent event) override;

private:
  std::set<IEventListener *> eventListeners;
};

}
