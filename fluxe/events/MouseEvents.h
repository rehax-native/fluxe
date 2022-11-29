#pragma once

namespace fluxe {

struct MouseEvent {
  void stopPropagation() {
    doesPropagate = false;
  }
  void stopImmediatePropagation() {
    doesPropagateToSiblings = false;
  }

  bool doesPropagate = true;
  bool doesPropagateToSiblings = true;
};

struct MouseUpEvent : MouseEvent
{
  float left;
  float top;
  int button;
};

struct MouseDownEvent : MouseEvent
{
  float left;
  float top;
  int button;
};

struct MouseMoveEvent : MouseEvent
{
  float left;
  float top;
  bool isDown = false;
};

struct MouseEnterEvent : MouseEvent
{
  float left;
  float top;
};

struct MouseExitEvent : MouseEvent
{
  float left;
  float top;
};

}
