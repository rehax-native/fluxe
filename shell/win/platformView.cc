#include "platformView.h"
#include <windows.h>
#include <stdlib.h>
#include <string.h>
#include <tchar.h>

#include <iostream>

#include "third_party/skia/include/core/SkData.h"
#include "third_party/skia/include/core/SkImage.h"
#include "third_party/skia/include/core/SkBitmap.h"
#include "third_party/skia/include/core/SkStream.h"
#include "third_party/skia/include/core/SkSurface.h"
#include "third_party/skia/include/core/SkCanvas.h"
#include "third_party/skia/include/core/SkRRect.h"

static LRESULT CALLBACK
fluxe_platform_view_callback(HWND window, UINT msg, WPARAM wparam, LPARAM lparam)
{
    LRESULT result = 0;

    switch (msg) {
        case WM_PAINT:
        {
            /*
                PAINTSTRUCT ps;
                HDC hdc;
                TCHAR greeting[] = _T("Helloxxx");

                hdc = BeginPaint(window, &ps);
                TextOut(hdc, 5, 5, greeting, _tcslen(greeting));
                EndPaint(window, &ps);
                */
            result = 1;

            RECT rect;
            GetWindowRect(window, &rect);

            int dpi = GetDpiForWindow(window);
            float scale = static_cast<float>(dpi) / static_cast<float>(USER_DEFAULT_SCREEN_DPI);

            int width = rect.right - rect.left;
            int height = rect.bottom - rect.top;

            auto view = (fluxe::FluxePlatformView*)GetWindowLongPtrW(window, GWLP_USERDATA);
            auto renderCallback = view->getRenderCallback();

            // static int count = -1;
            // count++;
            // if (count < 1) {
            //   result = DefWindowProcA(window, msg, wparam, lparam);
            //   break;
            // }
            sk_sp<SkSurface> surface = renderCallback(width, height, scale);
            //     PAINTSTRUCT ps;
            //     HDC hdc;
            //     TCHAR greeting[] = _T("Helloxxx");

            //     hdc = BeginPaint(window, &ps);
            //     TextOut(hdc, 5, 5, greeting, _tcslen(greeting));
            //     EndPaint(window, &ps);
            // break;
            SkPixmap pixmap;
            surface->peekPixels(&pixmap);
            /*

            SkBitmap bmp;
            bmp.installPixels(pixmap);

            return bmp;
            */

            HDC dc = GetDC(window);
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
            ReleaseDC(window, dc);

            result = DefWindowProcA(window, msg, wparam, lparam);
        }
            break;
        default:
            result = DefWindowProcA(window, msg, wparam, lparam);
            break;
    }

    return result;
}

const wchar_t FLUXE_VIEW_CLASS_NAME[] = L"FLUXE_VIEW";

fluxe::FluxePlatformView::FluxePlatformView()
{
  static bool hasRegisteredClass = false;
  if (!hasRegisteredClass) {
    hasRegisteredClass = true;

    HINSTANCE hInstance = (HINSTANCE)GetModuleHandle(nullptr);
    STARTUPINFO si;
    GetStartupInfo(&si);
    int nCmdShow = si.wShowWindow;

    WNDCLASSEX window_class;
    window_class.cbSize = sizeof(WNDCLASSEX);
    window_class.style = CS_HREDRAW | CS_VREDRAW;
    window_class.lpfnWndProc = fluxe_platform_view_callback;
    window_class.cbClsExtra = 0;
    window_class.cbWndExtra = 0;
    window_class.hInstance = hInstance;
    window_class.hIcon = LoadIcon(hInstance, MAKEINTRESOURCE(IDI_APPLICATION));
    window_class.hCursor = LoadCursor(NULL, IDC_ARROW);
    // window_class.hbrBackground = (HBRUSH)(COLOR_WINDOW+1);
    window_class.hbrBackground = 0;
    window_class.lpszMenuName = NULL;
    window_class.lpszClassName = FLUXE_VIEW_CLASS_NAME;
    window_class.hIconSm = LoadIcon(hInstance, MAKEINTRESOURCE(IDI_APPLICATION));

    if (!RegisterClassEx(&window_class)) {
        exit(621);
    }
  }
}

void fluxe::FluxePlatformView::attachToWindow(HWND parentWindow)
{
  HINSTANCE hInstance = (HINSTANCE)GetModuleHandle(nullptr);

  HWND window = CreateWindow(
    FLUXE_VIEW_CLASS_NAME,
    L"Fluxe View",
    WS_CHILD | WS_VISIBLE | SS_LEFT | SS_NOTIFY,
    0, 0,
    600, 600,
    parentWindow,
    NULL,
    hInstance,
    NULL
  );

  if (!window) {
    exit(622);
  }

  SetWindowLongPtrW(window, GWLP_USERDATA, (LONG_PTR) this);
  // UpdateWindow(window);

  hWnd = window;
}

void fluxe::FluxePlatformView::setNeedsRerender()
{
  UpdateWindow(hWnd);
}

std::function<sk_sp<fluxe::Surface>(int, int, float)> fluxe::FluxePlatformView::getRenderCallback() { return renderCallback; }

void fluxe::FluxePlatformView::setRenderCallback(std::function<sk_sp<Surface>(int, int, float)> callback) { renderCallback = callback; }
void fluxe::FluxePlatformView::setMouseDownCallback(std::function<void(float left, float top, int button)> callback) { mouseDownCallback = callback; }
void fluxe::FluxePlatformView::setMouseUpCallback(std::function<void(float left, float top, int button)> callback) { mouseUpCallback = callback; }
void fluxe::FluxePlatformView::setMouseMoveCallback(std::function<void(float left, float top)> callback) { mouseMoveCallback = callback; }
void fluxe::FluxePlatformView::setKeyDownCallback(std::function<void(int code)> callback) { keyDownCallback = callback; }
void fluxe::FluxePlatformView::setKeyUpCallback(std::function<void(int code)> callback) { keyUpCallback = callback; }
void fluxe::FluxePlatformView::setTextCallback(std::function<void(const char *)> callback) { textCallback = callback; }
void fluxe::FluxePlatformView::setMoveLeftCallback(std::function<void(bool select)> callback) { moveLeftCallback = callback; }
void fluxe::FluxePlatformView::setMoveRightCallback(std::function<void(bool select)> callback) { moveRightCallback = callback; }
void fluxe::FluxePlatformView::setMoveWordLeftCallback(std::function<void(bool select)> callback) { moveWordLeftCallback = callback; }
void fluxe::FluxePlatformView::setMoveWordRightCallback(std::function<void(bool select)> callback) { moveWordRightCallback = callback; }
void fluxe::FluxePlatformView::setMoveBackwardCallback(std::function<void(bool select)> callback) { moveBackwardCallback = callback; }
void fluxe::FluxePlatformView::setMoveForwardCallback(std::function<void(bool select)> callback) { moveForwardCallback = callback; }
void fluxe::FluxePlatformView::setDeleteBackwardCallback(std::function<void(void)> callback) { deleteBackwardCallback = callback; }
void fluxe::FluxePlatformView::setDeleteForwardCallback(std::function<void(void)> callback) { deleteForwardCallback = callback; }
void fluxe::FluxePlatformView::setSelectAllCallback(std::function<void(void)> callback) { selectAllCallback = callback; }
