#include "platformWindow.h"
#include "platformView.h"

#define NOMINMAX

#include <windows.h>
#include <stdlib.h>
#include <string.h>
#include <tchar.h>

#include <iostream>

static LRESULT CALLBACK
window_callback(HWND window, UINT msg, WPARAM wparam, LPARAM lparam)
{
    LRESULT result = 0;

    // PAINTSTRUCT ps;
    // HDC hdc;
    // TCHAR greeting[] = _T("Hellxo");

    switch (msg) {
        case WM_CLOSE:
        case WM_DESTROY:
            PostQuitMessage(0);
            break;
       /*
        case WM_PAINT:
            hdc = BeginPaint(window, &ps);
            TextOut(hdc, 5, 5, greeting, _tcslen(greeting));
            EndPaint(window, &ps);
            break;
         */   
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

    // WNDCLASSA window_class = {
    //     .style = CS_HREDRAW | CS_VREDRAW | CS_OWNDC,
    //     .lpfnWndProc = window_callback,
    //     .hInstance = hInstance,
    //     .hCursor = LoadCursor(0, IDC_ARROW),
    //     .hbrBackground = 0,
    //     .lpszClassName = "FLUXE_WIN",
    // };

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
    window_class.lpszClassName = L"FLUXE_WIN";
    window_class.hIconSm = LoadIcon(hInstance, MAKEINTRESOURCE(IDI_APPLICATION));

    // if (!RegisterClassA(&window_class)) {
    if (!RegisterClassEx(&window_class)) {
        exit(621);
    }

    // DWORD window_style = WS_OVERLAPPEDWINDOW;
    // HWND window = CreateWindowExA(
    //     0,
    //     window_class.lpszClassName,
    //     "Window Title",
    //     window_style,
    //     CW_USEDEFAULT,
    //     CW_USEDEFAULT,
    //     600,
    //     600,
    //     0,
    //     0,
    //     hInstance,
    //     0
    // );
    HWND window = CreateWindow(
        window_class.lpszClassName,
        L"Window Title",
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
