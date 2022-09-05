#pragma once


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
  void setRenderCallback(std::function<void(int, int, float, sk_sp<SkSurface> surface)> callback);
  void setMouseCallback(std::function<void(ShellMouseInstruction)> callback);
  void setKeyCallback(std::function<void(ShellKeyboardKeyInstruction)> callback);
  void setKeyboardMoveCallback(std::function<void(ShellKeyboardMoveInstruction)> callback);
  void setTextCallback(std::function<void(const char*)> callback);

  void setCanHandleKeyboardCommandCallback(std::function<bool(ShellKeyboardCommand instruction)> callback);
  void setKeyboardCommandCallback(std::function<void(ShellKeyboardCommand instruction)> callback);

  std::function<void(int, int, float, sk_sp<fluxe::Surface>)> getRenderCallback();
  std::function<void(ShellMouseInstruction)> getMouseCallback();
  std::function<void(ShellKeyboardKeyInstruction)> getKeyCallback();
  std::function<void(ShellKeyboardMoveInstruction)> getKeyboardMoveCallback();
  std::function<void(const char*)> getTextCallback();
  std::function<bool(ShellKeyboardCommand instruction)> getCanHandleKeyboardCommandCallback();
  std::function<void(ShellKeyboardCommand instruction)> getKeyboardCommandCallback();

  void setNeedsRerender();

  bool isShiftDown = false;
  bool isCtrlDown = false;
  bool isAltDown = false;
  bool isWinDown = false;
  bool hasPainted = false;
  HWND hWnd = nullptr;

private:
//   HINSTANCE mHInstance = nullptr;

protected:

  std::function<void(int, int, float, sk_sp<fluxe::Surface>)> renderCallback;
  std::function<void(ShellMouseInstruction instruction)> mouseCallback;
  std::function<void(ShellKeyboardKeyInstruction instruction)> keyCallback;
  std::function<void(ShellKeyboardMoveInstruction instruction)> moveCallback;
  std::function<void(const char * str)> textCallback;
  std::function<bool(ShellKeyboardCommand instruction)> canHandleKeyboardCommandCallback;
  std::function<void(ShellKeyboardCommand instruction)> keyboardCommandCallback;

};

}