#pragma once

namespace fluxe {

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

}
