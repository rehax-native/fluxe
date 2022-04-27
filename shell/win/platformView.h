#pragma once

#define NOMINMAX

#include <functional>
#include <windows.h>
#include "render_backend/skia/canvas.h"

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
  void setMouseDownCallback(std::function<void(float left, float top, int button)> callback);
  void setMouseMoveCallback(std::function<void(float left, float top)> callback);
  void setMouseUpCallback(std::function<void(float left, float top, int button)> callback);
  void setTextCallback(std::function<void(const char* str)> callback);
  void setKeyDownCallback(std::function<void(int code)> callback);
  void setKeyUpCallback(std::function<void(int code)> callback);
  
  void setMoveLeftCallback(std::function<void(bool select)> callback);
  void setMoveRightCallback(std::function<void(bool select)> callback);
  void setMoveWordLeftCallback(std::function<void(bool select)> callback);
  void setMoveWordRightCallback(std::function<void(bool select)> callback);
  void setMoveBackwardCallback(std::function<void(bool select)> callback);
  void setMoveForwardCallback(std::function<void(bool select)> callback);
  void setDeleteBackwardCallback(std::function<void(void)> callback);
  void setDeleteForwardCallback(std::function<void(void)> callback);
  void setSelectAllCallback(std::function<void(void)> callback);

  void setNeedsRerender();

  std::function<sk_sp<fluxe::Surface>(int, int, float)> getRenderCallback();

private:
  HWND hWnd = nullptr;
//   HINSTANCE mHInstance = nullptr;

protected:
  std::function<sk_sp<fluxe::Surface>(int, int, float)> renderCallback;
  std::function<void(float left, float top, int button)> mouseDownCallback;
  std::function<void(float left, float top, int button)> mouseUpCallback;
  std::function<void(float left, float top)> mouseMoveCallback;
  std::function<void(const char * str)> textCallback;
  std::function<void(int code)> keyDownCallback;
  std::function<void(int code)> keyUpCallback;
  std::function<void(bool select)> moveLeftCallback;
  std::function<void(bool select)> moveRightCallback;
  std::function<void(bool select)> moveWordLeftCallback;
  std::function<void(bool select)> moveWordRightCallback;
  std::function<void(bool select)> moveBackwardCallback;
  std::function<void(bool select)> moveForwardCallback;
  std::function<void(void)> deleteBackwardCallback;
  std::function<void(void)> deleteForwardCallback;
  std::function<void(void)> selectAllCallback;
};

}
