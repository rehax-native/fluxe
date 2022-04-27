#include "shell/win/platformView.h"
#include "shell/win/platformWindow.h"

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
            } else {
                TranslateMessage(&msg);
                DispatchMessageA(&msg);
            }
        }
    }

    return 0;
}
