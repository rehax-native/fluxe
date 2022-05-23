#include "engine.h"

#include "shell/win/platformWindow.h"
#include "shell/win/platformView.h"

#include "third_party/skia/include/core/SkData.h"
#include "third_party/skia/include/core/SkImage.h"
#include "third_party/skia/include/core/SkBitmap.h"
#include "third_party/skia/include/core/SkSurface.h"
#include <windows.h>
#include <stdlib.h>
#include <string.h>
#include <tchar.h>

fluxe::Engine::Engine()
{}

fluxe::Engine::~Engine()
{}

void * fluxe::Engine::createPlatformWindow()
{
  void * window = OpenPlatformWindow();
  return window;
}

void fluxe::Engine::closePlatformWindow(void * window)
{}

void fluxe::Engine::attachToPlatformWindow(void * platformWindow)
// fluxe::FluxePlatformView * fluxe::Engine::attachToPlatformWindow(void * platformWindow)
{
  auto view = new FluxePlatformView();
  this->view = view;
  view->attachToWindow((HWND) platformWindow);
//   return view;
}

// void fluxe::Engine::detachFromPlatformWindow(fluxe::FluxePlatformView * platformWindow)
void fluxe::Engine::detachFromPlatformWindow()
{}


void fluxe::Engine::attachToPlatformView(void * platformView)
{
  auto view = new FluxePlatformView();
  view->attachToWindow((HWND) platformView);
}

void fluxe::Engine::detachFromPlatformView()
{

}

void fluxe::Engine::startMainLoop()
{
  MSG msg;
  while (GetMessageA(&msg, 0, 0, 0))
  {
    if (msg.message == WM_QUIT) {
    } else if (msg.message == WM_PAINT) {
        DefWindowProcA(msg.hwnd, msg.message, msg.wParam, msg.lParam);
    } else {
      TranslateMessage(&msg);
      DispatchMessageA(&msg);
      // if (TranslateAccelerator(msg.hwnd, haccl, &msg) == 0) 
      // { 
        // TranslateMessage(&msg); 
        // DispatchMessage(&msg); 
      // } 
    }
  }
}

void fluxe::Engine::stopMainLoop()
{
  PostQuitMessage(0);
}

void fluxe::Engine::startEngine()
{}

void fluxe::Engine::stopEngine()
{}

void fluxe::Engine::setRenderCallback(std::function<sk_sp<fluxe::Surface>(int, int, float)> callback)
{
  FluxePlatformView * view = (FluxePlatformView *) this->view;
  view->setRenderCallback(callback);
}

void fluxe::Engine::setNeedsRerender()
{
  FluxePlatformView * view = (FluxePlatformView *) this->view;
  view->setNeedsRerender();
}

void fluxe::Engine::setMouseCallback(std::function<void(ShellMouseInstruction instruction)> callback)
{
  FluxePlatformView * view = (FluxePlatformView *) this->view;
  view->setMouseCallback(callback);
}

void fluxe::Engine::setTextCallback(std::function<void(const char* str)> callback)
{
  FluxePlatformView * view = (FluxePlatformView *) this->view;
  view->setTextCallback(callback);
}

void fluxe::Engine::setKeyCallback(std::function<void(ShellKeyboardKeyInstruction)> callback)
{
  FluxePlatformView * view = (FluxePlatformView *) this->view;
  view->setKeyCallback(callback);
}

void fluxe::Engine::setMoveCallback(std::function<void(ShellKeyboardMoveInstruction)> callback)
{
  FluxePlatformView * view = (FluxePlatformView *) this->view;
  view->setKeyboardMoveCallback(callback);
}