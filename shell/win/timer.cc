#include "timer.h"
#include <windows.h>

void FluxeTimerProc(HWND win, UINT p1, UINT_PTR p2, DWORD p3)
{

}

fluxe::Timer * fluxe::Timer::startInterval(int intervalMs, std::function<void(void)> tick)
{
    static unsigned int fluxeTimerId = 4721;
    unsigned int nextId = fluxeTimerId++;
    HWND win = nullptr;
    SetTimer(win, nextId, intervalMs, (TIMERPROC)FluxeTimerProc);

    Timer * timer = new Timer();
    timer->timer = nextId;
    return timer;
}

void fluxe::Timer::stopTimer(fluxe::Timer * timer)
{
    HWND win = nullptr;
    KillTimer(win, timer->timer);
    timer->timer = 0;
    delete timer;
}

// bool fluxe::Timer::isRunning(fluxe::Timer * timer)
// {
//     return timer.timer != nullptr;
// }