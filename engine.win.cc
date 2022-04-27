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

fluxe::FluxePlatformView * fluxe::Engine::attachToPlatformWindow(void * platformWindow)
{
  auto view = new FluxePlatformView();
  view->attachToWindow((HWND) platformWindow);
  return view;
}

void fluxe::Engine::detachFromPlatformWindow(fluxe::FluxePlatformView * platformWindow)
{}

// void fluxe::Engine::setNeedsRerender()
// {}

void fluxe::Engine::startMainLoop()
{
  MSG msg;
  bool running = true;
  while (running) {
    while (PeekMessageA(&msg, 0, 0, 0, PM_REMOVE))
    {
      if (msg.message == WM_QUIT) {
        running = false;
      } else if (msg.message == WM_PAINT) {
          /*
        HWND window = msg.hwnd;
    PAINTSTRUCT ps;
    HDC hdc;
    TCHAR greeting[] = _T("Hello");

            hdc = BeginPaint(window, &ps);
            TextOut(hdc, 5, 5, greeting, _tcslen(greeting));
            EndPaint(window, &ps);
            */
          DefWindowProcA(msg.hwnd, msg.message, msg.wParam, msg.lParam);
      } else {
        TranslateMessage(&msg);
        DispatchMessageA(&msg);
      }
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
