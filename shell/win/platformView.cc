#include "platformView.h"
#include <windows.h>
#include <windowsx.h>
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
    auto view = (fluxe::FluxePlatformView*)GetWindowLongPtrW(window, GWLP_USERDATA);

    switch (msg) {
        case WM_SIZE:
        case WM_WINDOWPOSCHANGED:
        {
          if (view != nullptr && view->hasPainted) {
            view->setNeedsRerender();
          }
        }
          break;
        case WM_PAINT:
        {
            result = 1;

            RECT rect;
            GetWindowRect(window, &rect);

            int dpi = GetDpiForWindow(window);
            float scale = static_cast<float>(dpi) / static_cast<float>(USER_DEFAULT_SCREEN_DPI);

            int width = rect.right - rect.left;
            int height = rect.bottom - rect.top;

            auto renderCallback = view->getRenderCallback();

            sk_sp<SkSurface> surface = renderCallback(width, height, scale);
            SkPixmap pixmap;
            surface->peekPixels(&pixmap);

            HDC dc = GetDC(window);
            BITMAPINFO bmi;
            memset(&bmi, 0, sizeof(bmi));
            bmi.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
            bmi.bmiHeader.biWidth = width;
            bmi.bmiHeader.biHeight = -height;
            bmi.bmiHeader.biPlanes = 1;
            bmi.bmiHeader.biBitCount = 32;
            bmi.bmiHeader.biCompression = BI_RGB;

            StretchDIBits(dc, 0, 0, width, height, 0, 0, width, height, pixmap.addr(), &bmi, DIB_RGB_COLORS, SRCCOPY);
            ReleaseDC(window, dc);

            result = DefWindowProcA(window, msg, wparam, lparam);

            view->hasPainted = true;
        }
          break;

          // WM_CAPTURECHANGED	Sent to the window that is losing the mouse capture.
          // WM_LBUTTONDBLCLK	Posted when the user double-clicks the left mouse button while the cursor is in the client area of a window. If the mouse is not captured, the message is posted to the window beneath the cursor. Otherwise, the message is posted to the window that has captured the mouse.
          // WM_LBUTTONDOWN	Posted when the user presses the left mouse button while the cursor is in the client area of a window. If the mouse is not captured, the message is posted to the window beneath the cursor. Otherwise, the message is posted to the window that has captured the mouse.
        case WM_LBUTTONDOWN:
          view->getMouseCallback()({
            .button = 0,
            .left = (float) GET_X_LPARAM(lparam),
            .top = (float) GET_Y_LPARAM(lparam),
            .isDown = true,
          });
          break;
          // WM_LBUTTONUP	Posted when the user releases the left mouse button while the cursor is in the client area of a window. If the mouse is not captured, the message is posted to the window beneath the cursor. Otherwise, the message is posted to the window that has captured the mouse.
        case WM_LBUTTONUP:
          view->getMouseCallback()({
            .button = 0,
            .left = (float) GET_X_LPARAM(lparam),
            .top = (float) GET_Y_LPARAM(lparam),
            .isUp = true,
          });
          break;
          // WM_MBUTTONDBLCLK	Posted when the user double-clicks the middle mouse button while the cursor is in the client area of a window. If the mouse is not captured, the message is posted to the window beneath the cursor. Otherwise, the message is posted to the window that has captured the mouse.
          // WM_MBUTTONDOWN	Posted when the user presses the middle mouse button while the cursor is in the client area of a window. If the mouse is not captured, the message is posted to the window beneath the cursor. Otherwise, the message is posted to the window that has captured the mouse.
        case WM_MBUTTONDOWN:
          view->getMouseCallback()({
            .button = 2,
            .left = (float) GET_X_LPARAM(lparam),
            .top = (float) GET_Y_LPARAM(lparam),
            .isDown = true,
          });
          break;
          // WM_MBUTTONUP	Posted when the user releases the middle mouse button while the cursor is in the client area of a window. If the mouse is not captured, the message is posted to the window beneath the cursor. Otherwise, the message is posted to the window that has captured the mouse.
        case WM_MBUTTONUP:
          view->getMouseCallback()({
            .button = 2,
            .left = (float) GET_X_LPARAM(lparam),
            .top = (float) GET_Y_LPARAM(lparam),
            .isUp = true,
          });
          break;
          // WM_MOUSEACTIVATE	Sent when the cursor is in an inactive window and the user presses a mouse button. The parent window receives this message only if the child window passes it to the DefWindowProc function.
          // WM_MOUSEHOVER	Posted to a window when the cursor hovers over the client area of the window for the period of time specified in a prior call to TrackMouseEvent.
          // WM_MOUSEHWHEEL	Sent to the focus window when the mouse's horizontal scroll wheel is tilted or rotated. TheDefWindowProcfunction propagates the message to the window's parent. There should be no internal forwarding of the message, because DefWindowProc propagates it up the parent chain until it finds a window that processes it.
          // WM_MOUSELEAVE	Posted to a window when the cursor leaves the client area of the window specified in a prior call to TrackMouseEvent.
          // WM_MOUSEMOVE	Posted to a window when the cursor moves. If the mouse is not captured, the message is posted to the window that contains the cursor. Otherwise, the message is posted to the window that has captured the mouse.
        case WM_MOUSEMOVE:
          view->getMouseCallback()({
            .left = (float) GET_X_LPARAM(lparam),
            .top = (float) GET_Y_LPARAM(lparam),
            .isMove = true,
          });
          break;
          // WM_MOUSEWHEEL	Sent to the focus window when the mouse wheel is rotated. The DefWindowProc function propagates the message to the window's parent. There should be no internal forwarding of the message, because DefWindowProc propagates it up the parent chain until it finds a window that processes it.
          // WM_NCHITTEST	Sent to a window in order to determine what part of the window corresponds to a particular screen coordinate. This can happen, for example, when the cursor moves, when a mouse button is pressed or released, or in response to a call to a function such as WindowFromPoint. If the mouse is not captured, the message is sent to the window beneath the cursor. Otherwise, the message is sent to the window that has captured the mouse.
          // WM_NCLBUTTONDBLCLK	Posted when the user double-clicks the left mouse button while the cursor is within the nonclient area of a window. This message is posted to the window that contains the cursor. If a window has captured the mouse, this message is not posted.
          // WM_NCLBUTTONDOWN	Posted when the user presses the left mouse button while the cursor is within the nonclient area of a window. This message is posted to the window that contains the cursor. If a window has captured the mouse, this message is not posted.
          // WM_NCLBUTTONUP	Posted when the user releases the left mouse button while the cursor is within the nonclient area of a window. This message is posted to the window that contains the cursor. If a window has captured the mouse, this message is not posted.
          // WM_NCMBUTTONDBLCLK	Posted when the user double-clicks the middle mouse button while the cursor is within the nonclient area of a window. This message is posted to the window that contains the cursor. If a window has captured the mouse, this message is not posted.
          // WM_NCMBUTTONDOWN	Posted when the user presses the middle mouse button while the cursor is within the nonclient area of a window. This message is posted to the window that contains the cursor. If a window has captured the mouse, this message is not posted.
          // WM_NCMBUTTONUP	Posted when the user releases the middle mouse button while the cursor is within the nonclient area of a window. This message is posted to the window that contains the cursor. If a window has captured the mouse, this message is not posted.
          // WM_NCMOUSEHOVER	Posted to a window when the cursor hovers over the nonclient area of the window for the period of time specified in a prior call toTrackMouseEvent.
          // WM_NCMOUSELEAVE	Posted to a window when the cursor leaves the nonclient area of the window specified in a prior call toTrackMouseEvent.
          // WM_NCMOUSEMOVE	Posted to a window when the cursor is moved within the nonclient area of the window. This message is posted to the window that contains the cursor. If a window has captured the mouse, this message is not posted.
          // WM_NCRBUTTONDBLCLK	Posted when the user double-clicks the right mouse button while the cursor is within the nonclient area of a window. This message is posted to the window that contains the cursor. If a window has captured the mouse, this message is not posted.
          // WM_NCRBUTTONDOWN	Posted when the user presses the right mouse button while the cursor is within the nonclient area of a window. This message is posted to the window that contains the cursor. If a window has captured the mouse, this message is not posted.
          // WM_NCRBUTTONUP	Posted when the user releases the right mouse button while the cursor is within the nonclient area of a window. This message is posted to the window that contains the cursor. If a window has captured the mouse, this message is not posted.
          // WM_NCXBUTTONDBLCLK	Posted when the user double-clicks the first or second X button while the cursor is in the nonclient area of a window. This message is posted to the window that contains the cursor. If a window has captured the mouse, this message is not posted.
          // WM_NCXBUTTONDOWN	Posted when the user presses the first or second X button while the cursor is in the nonclient area of a window. This message is posted to the window that contains the cursor. If a window has captured the mouse, this message is not posted.
          // WM_NCXBUTTONUP	Posted when the user releases the first or second X button while the cursor is in the nonclient area of a window. This message is posted to the window that contains the cursor. If a window has captured the mouse, this message is not posted.
          // WM_RBUTTONDBLCLK	Posted when the user double-clicks the right mouse button while the cursor is in the client area of a window. If the mouse is not captured, the message is posted to the window beneath the cursor. Otherwise, the message is posted to the window that has captured the mouse.
          // WM_RBUTTONDOWN	Posted when the user presses the right mouse button while the cursor is in the client area of a window. If the mouse is not captured, the message is posted to the window beneath the cursor. Otherwise, the message is posted to the window that has captured the mouse.
        case WM_RBUTTONDOWN:
          view->getMouseCallback()({
            .button = 1,
            .left = (float) GET_X_LPARAM(lparam),
            .top = (float) GET_Y_LPARAM(lparam),
            .isDown = true,
          });
          break;
          // WM_RBUTTONUP	Posted when the user releases the right mouse button while the cursor is in the client area of a window. If the mouse is not captured, the message is posted to the window beneath the cursor. Otherwise, the message is posted to the window that has captured the mouse.
        case WM_RBUTTONUP:
          view->getMouseCallback()({
            .button = 1,
            .left = (float) GET_X_LPARAM(lparam),
            .top = (float) GET_Y_LPARAM(lparam),
            .isUp = true,
          });
          break;
          // WM_XBUTTONDBLCLK	Posted when the user double-clicks the first or second X button while the cursor is in the client area of a window. If the mouse is not captured, the message is posted to the window beneath the cursor. Otherwise, the message is posted to the window that has captured the mouse.
          // WM_XBUTTONDOWN	Posted when the user presses the first or second X button while the cursor is in the client area of a window. If the mouse is not captured, the message is posted to the window beneath the cursor. Otherwise, the message is posted to the window that has captured the mouse.
          // WM_XBUTTONUP	Posted when the user releases the first or second X button while the cursor is in the client area of a window. If the mouse is not captured, the message is posted to the window beneath the cursor. Otherwise, the message is posted to the window that has captured the mouse.
        
        case WM_CHAR:
          {

            switch (wparam) {
              case 0x08: // Backspace
              // already handled in WM_KEYDOWN
                // view->getKeyboardMoveCallback()({
                //   .isBackwards = true,
                //   .isWord = view->isCtrlDown,
                //   .isDelete = true,
                // });
                break;
              // case 0x0A: // Linefeed
              // case 0x1B: // Escape
              case 0x09: // Tab
                if (view->isShiftDown) {
                  view->getKeyboardMoveCallback()({
                    .isBackwards = true,
                    .isTab = true,
                  });
                } else {
                  view->getKeyboardMoveCallback()({
                    .isForwards = true,
                    .isTab = true,
                  });
                }
                break;
              // case 0x0D: // Carriage Return 
              default:
              {

                if (view->isCtrlDown) {
                  break;
                }
                TCHAR tStr[2];
                tStr[0] = (TCHAR) wparam;
                tStr[1] = '\0';

                std::wstring test(&tStr[0]); //convert to wstring
                std::string str(test.begin(), test.end());
                view->getTextCallback()(str.c_str());
              }
            }
          }
          break;

        case WM_KEYUP:
          view->getKeyCallback()({
            .code = (int) wparam,
            .isUp = true,
          });
          switch (wparam) {
            case VK_SHIFT:
              view->isShiftDown = false;
              break;
            case VK_CONTROL:
              view->isCtrlDown = false;
              break;
          }
          break;
        case WM_KEYDOWN:
          view->getKeyCallback()({
            .code = (int) wparam,
            .isDown = true,
          });
          switch (wparam) {
            case VK_SHIFT:
              view->isShiftDown = true;
              break;
            case VK_CONTROL:
              view->isCtrlDown = true;
              break;
            case VK_LEFT:
              view->getKeyboardMoveCallback()({
                .isLeft = true,
                .isWord = view->isCtrlDown,
                .isSelect = view->isShiftDown,
              });
              break;
            case VK_RIGHT:
              view->getKeyboardMoveCallback()({
                .isRight = true,
                .isWord = view->isCtrlDown,
                .isSelect = view->isShiftDown,
              });
              break;
            case VK_UP:
              view->getKeyboardMoveCallback()({
                .isUp = true,
                .isWord = view->isCtrlDown,
                .isSelect = view->isShiftDown,
              });
              break;
            case VK_DOWN:
              view->getKeyboardMoveCallback()({
                .isDown = true,
                .isWord = view->isCtrlDown,
                .isSelect = view->isShiftDown,
              });
              break;
            case VK_HOME:
              view->getKeyboardMoveCallback()({
                .isBackwards = true,
                .isDocument = true,
                .isSelect = view->isShiftDown,
              });
              break;
            case VK_END:
              view->getKeyboardMoveCallback()({
                .isForwards = true,
                .isDocument = true,
                .isSelect = view->isShiftDown,
              });
              break;
            case VK_BACK:
              view->getKeyboardMoveCallback()({
                .isBackwards = true,
                .isWord = view->isCtrlDown,
                .isDelete = true,
              });
              break;
            case VK_CLEAR:
            case VK_DELETE:
              view->getKeyboardMoveCallback()({
                .isForwards = true,
                .isWord = view->isCtrlDown,
                .isDelete = true,
              });
              break;
            // case VK_ESCAPE:
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
    EnableMouseInPointer(true);
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
  EnableWindow(window, true);
  SetFocus(window);

  hWnd = window;
}

void fluxe::FluxePlatformView::setNeedsRerender()
{
  InvalidateRect(
    hWnd,
    nullptr,
    true
  );
  UpdateWindow(hWnd);
}

std::function<sk_sp<fluxe::Surface>(int, int, float)> fluxe::FluxePlatformView::getRenderCallback() { return renderCallback; }
std::function<void(ShellMouseInstruction)> fluxe::FluxePlatformView::getMouseCallback() { return mouseCallback; }
std::function<void(ShellKeyboardKeyInstruction)> fluxe::FluxePlatformView::getKeyCallback() { return keyCallback; }
std::function<void(ShellKeyboardMoveInstruction)> fluxe::FluxePlatformView::getKeyboardMoveCallback() { return moveCallback; }
std::function<void(const char*)> fluxe::FluxePlatformView::getTextCallback() { return textCallback; }

void fluxe::FluxePlatformView::setRenderCallback(std::function<sk_sp<Surface>(int, int, float)> callback) { renderCallback = callback; setNeedsRerender(); }
void fluxe::FluxePlatformView::setMouseCallback(std::function<void(ShellMouseInstruction)> callback) { mouseCallback = callback; }
void fluxe::FluxePlatformView::setKeyCallback(std::function<void(ShellKeyboardKeyInstruction)> callback) { keyCallback = callback; }
void fluxe::FluxePlatformView::setKeyboardMoveCallback(std::function<void(ShellKeyboardMoveInstruction)> callback) { moveCallback = callback; }
void fluxe::FluxePlatformView::setTextCallback(std::function<void(const char*)> callback) { textCallback = callback; }
