#pragma once

#define NOMINMAX

#include <functional>
#include <windows.h>
#include "render_backend/skia/canvas.h"
#include "../callbacks.h"

// #ifdef FLUXE_USE_OPENGL
// #define VIEW_BASE NSOpenGLView
// #else
// #define VIEW_BASE NSView
// #endif

namespace fluxe {

class FluxePlatformView
{
public:

  FluxePlatformView();
  void attachToWindow(HWND parentWindow);

  /**
   * Callbacks
   */
  void setRenderCallback(std::function<sk_sp<Surface>(int, int, float)> callback);
  void setMouseCallback(std::function<void(ShellMouseInstruction)> callback);
  void setKeyCallback(std::function<void(ShellKeyboardKeyInstruction)> callback);
  void setKeyboardMoveCallback(std::function<void(ShellKeyboardMoveInstruction)> callback);
  void setTextCallback(std::function<void(const char*)> callback);

  std::function<sk_sp<fluxe::Surface>(int, int, float)> getRenderCallback();
  std::function<void(ShellMouseInstruction)> getMouseCallback();
  std::function<void(ShellKeyboardKeyInstruction)> getKeyCallback();
  std::function<void(ShellKeyboardMoveInstruction)> getKeyboardMoveCallback();
  std::function<void(const char*)> getTextCallback();

  void setNeedsRerender();

  bool isShiftDown = false;
  bool isCtrlDown = false;

private:
  HWND hWnd = nullptr;
//   HINSTANCE mHInstance = nullptr;

protected:

  std::function<sk_sp<fluxe::Surface>(int, int, float)> renderCallback;
  std::function<void(ShellMouseInstruction instruction)> mouseCallback;
  std::function<void(ShellKeyboardKeyInstruction instruction)> keyCallback;
  std::function<void(ShellKeyboardMoveInstruction instruction)> moveCallback;
  std::function<void(const char * str)> textCallback;

};

}