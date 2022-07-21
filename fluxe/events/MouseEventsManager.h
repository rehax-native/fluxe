#pragma once

#include <vector>
#include <unordered_map>
#include "../misc/Object.h"
#include "../../shell/callbacks.h"

namespace fluxe {

class View;

struct MouseUpEvent
{
  float left;
  float top;
  int button;
};

struct MouseDownEvent
{
  float left;
  float top;
  int button;
};

struct MouseMoveEvent
{
  float left;
  float top;
};

struct MouseEnterEvent
{
  float left;
  float top;
};

struct MouseExitEvent
{
  float left;
  float top;
};

class IMouseEventListener
{
};

class IMouseEventListenerContainer
{
  std::vector<IMouseEventListener> mouseEventListeners;
};

class IMouseDownEventListener : public IMouseEventListener
{
public:
  constexpr static const char * EventName = "MouseDown";
  virtual void onMouseDown(MouseDownEvent event) = 0;
};
class IMouseUpEventListener : public IMouseEventListener
{
public:
  virtual void onMouseUp(MouseUpEvent event) = 0;
};
class IMouseMoveEventListener : public IMouseEventListener
{
public:
  virtual void onMouseMove(MouseMoveEvent event) = 0;
};
class IMouseEnterExitEventListener : public IMouseEventListener
{
public:
  virtual void onMouseEnter(MouseEnterEvent event) = 0;
  virtual void onMouseExit(MouseExitEvent event) = 0;
};

class MouseEventsManager 
{

public:
  MouseEventsManager(ObjectPointer<View> rootView);

  void handleInstruction(ShellMouseInstruction instruction);
  void handleMouseDown(MouseDownEvent event);
  void handleMouseUp(MouseUpEvent event);
  void handleMouseMove(MouseMoveEvent event);

private:
  ObjectPointer<View> findViewAtPosition(float x, float y, ObjectPointer<View> view);

  ObjectPointer<View> rootView;
  // std::unordered_map<ObjectPointer<View>, bool> previousMouseMoveListeners;
};

}
