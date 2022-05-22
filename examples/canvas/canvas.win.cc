#include "shell/win/platformView.h"
#include "shell/win/platformWindow.h"
#include "./canvasExample.cc"
#include <iostream>

#include <stdlib.h>
#include <string.h>
#include <tchar.h>

int WINAPI WinMain(HINSTANCE inst, HINSTANCE prev, LPSTR cmd, int show) {
  void * window = OpenPlatformWindow();

  MSG msg;

  // Main message loop:
  bool running = true;
  while (running) {
    while (PeekMessageA(&msg, 0, 0, 0, PM_REMOVE))
    {
      if (msg.message == WM_QUIT) {
        running = false;
      } else if (msg.message == WM_PAINT || msg.message == WM_SIZE) {
          /*
          
          PAINTSTRUCT ps;
          HDC hdc;
          TCHAR greeting[] = _T("Hello3");
        hdc = BeginPaint((HWND)window, &ps);
        TextOut(hdc, 5, 5, greeting, _tcslen(greeting));
        EndPaint((HWND)window, &ps);
        continue;
        */
        RECT rect;
        GetWindowRect((HWND)window, &rect);

        int dpi = GetDpiForWindow((HWND)window);
        float scale = static_cast<float>(dpi) / static_cast<float>(USER_DEFAULT_SCREEN_DPI);

        int width = rect.right - rect.left;
        int height = rect.bottom - rect.top;

        sk_sp<SkSurface> surface = drawExample(width, height);
        SkPixmap pixmap;
        surface->peekPixels(&pixmap);
        /*
        
        SkBitmap bmp;
        bmp.installPixels(pixmap);
        return bmp;
        */

        HDC dc = GetDC((HWND) window);
        BITMAPINFO bmi;
        memset(&bmi, 0, sizeof(bmi));
        bmi.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
        bmi.bmiHeader.biWidth = width;
        bmi.bmiHeader.biHeight = -height;
        bmi.bmiHeader.biPlanes = 1;
        bmi.bmiHeader.biBitCount = 32;
        bmi.bmiHeader.biCompression = BI_RGB;
        // bmi.bmiHeader.biSizeImage = 0;
        // int ret = SetDIBitsToDevice(dc, 0, 0, width, height, 0, 0, 0, height, allocation, &bmi, DIB_RGB_COLORS);

        StretchDIBits(dc, 0, 0, width, height, 0, 0, width, height, pixmap.addr(), &bmi, DIB_RGB_COLORS, SRCCOPY);
        ReleaseDC((HWND)window, dc);

        DefWindowProcA((HWND) window, msg.message, msg.wParam, msg.lParam);
      } else {
        TranslateMessage(&msg);
        DispatchMessageA(&msg);
      }
    }
  }

  return 0;
}