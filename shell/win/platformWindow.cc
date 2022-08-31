#include "platformWindow.h"
#include "platformView.h"

#define NOMINMAX

#include <windows.h>
#include <stdlib.h>
#include <string.h>
#include <tchar.h>

#include <iostream>

BOOL CALLBACK GiveFocusToChildren(HWND hwnd, LPARAM lParam)
{
    SetFocus(hwnd);
    return true;
}

BOOL CALLBACK ResizeChildren(HWND hwnd, LPARAM lParam)
{
    HWND parent = reinterpret_cast<HWND>(lParam);
    RECT rect;
    GetWindowRect(parent, &rect);
    SetWindowPos(hwnd, 0, 0, 0, rect.right - rect.left, rect.bottom - rect.top, 0);
    return true;
}

static LRESULT CALLBACK
window_callback(HWND window, UINT msg, WPARAM wparam, LPARAM lparam)
{
    LRESULT result = 0;

    switch (msg) {
        case WM_CLOSE:
        case WM_DESTROY:
            PostQuitMessage(0);
            break;
        case WM_SIZE:
            EnumChildWindows(window, ResizeChildren, reinterpret_cast<LPARAM>(window));
            break;
        case WM_SETFOCUS:
        {
            EnumChildWindows(window, GiveFocusToChildren, lparam);
        }
        break;
        default:
            result = DefWindowProcA(window, msg, wparam, lparam);
            break;
    }

    return result;
}

void* OpenPlatformWindow()
{
    HINSTANCE hInstance = (HINSTANCE)GetModuleHandle(nullptr);
    STARTUPINFO si;
    GetStartupInfo(&si);
    int nCmdShow = si.wShowWindow;

    WNDCLASSEX window_class;
    window_class.cbSize = sizeof(WNDCLASSEX);
    window_class.style = CS_HREDRAW | CS_VREDRAW;
    window_class.lpfnWndProc = window_callback;
    window_class.cbClsExtra = 0;
    window_class.cbWndExtra = 0;
    window_class.hInstance = hInstance;
    window_class.hIcon = LoadIcon(hInstance, MAKEINTRESOURCE(IDI_APPLICATION));
    window_class.hCursor = LoadCursor(NULL, IDC_ARROW);
    // window_class.hbrBackground = (HBRUSH)(COLOR_WINDOW+1);
    window_class.hbrBackground = 0;
    window_class.lpszMenuName = NULL;
    window_class.lpszClassName = "FLUXE_WIN";
    window_class.hIconSm = LoadIcon(hInstance, MAKEINTRESOURCE(IDI_APPLICATION));

    if (!RegisterClassEx(&window_class)) {
        exit(621);
    }

    HWND window = CreateWindow(
        window_class.lpszClassName,
        "Window Title",
        WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, CW_USEDEFAULT,
        600, 600,
        NULL,
        NULL,
        hInstance,
        NULL
    );

    if (!window) {
        exit(622);
    }

    SetThreadDpiAwarenessContext(DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2);

    ShowWindow(window, nCmdShow);
    UpdateWindow(window);

    return window;
}