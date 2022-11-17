#include "platformWindow.h"
#include "platformView.h"

#define NOMINMAX

#include <windows.h>
#include <stdlib.h>
#include <string.h>
#include <tchar.h>

#include <iostream>

// #define GLFW_EXPOSE_NATIVE_WIN32
// #include <GLFW/glfw3.h>
// #include <GLFW/glfw3native.h>

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
        /*
        case WM_ERASEBKGND:
            std::cout << "erase" << std::endl;
            return 1;
        case WM_PAINT:
            std::cout << "parent paint" << std::endl;
            */
        default:
            //std::cout << "parent " << msg << std::endl;
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
    window_class.hbrBackground = (HBRUSH)(COLOR_WINDOW+1);
    // window_class.hbrBackground = 0;
    window_class.lpszMenuName = NULL;
    window_class.lpszClassName = "FLUXE_WIN";
    window_class.hIconSm = LoadIcon(hInstance, MAKEINTRESOURCE(IDI_APPLICATION));

    if (!RegisterClassEx(&window_class)) {
        exit(621);
    }

    HWND window = CreateWindowEx(
        WS_EX_APPWINDOW,
        window_class.lpszClassName,
        "Window Title",
        WS_OVERLAPPEDWINDOW | WS_CAPTION | WS_MAXIMIZEBOX | WS_THICKFRAME,
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
    /*
    if (!glfwInit()) {
        // TODO: Continue without GPU
    }
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 2);
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    //(uncomment to enable correct color spaces) glfwWindowHint(GLFW_SRGB_CAPABLE, GL_TRUE);
    glfwWindowHint(GLFW_STENCIL_BITS, 0);
    //glfwWindowHint(GLFW_ALPHA_BITS, 0);
    glfwWindowHint(GLFW_DEPTH_BITS, 0);
    // glfwWindowHint(GLFW_VISIBLE, GLFW_FALSE);
    GLFWwindow* glWindow = glfwCreateWindow(600, 600, "", NULL, NULL);
    glfwMakeContextCurrent(glWindow);

    return glfwGetWin32Window(glWindow);
    */
}