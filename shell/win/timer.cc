#include "timer.h"
#include <windows.h>
#include <unordered_map>

std::unordered_map<UINT_PTR, std::function<void(void)>> winTimerMap;

void FluxeTimerProc(HWND win, UINT p1, UINT_PTR p2, DWORD p3)
{
    auto tick = winTimerMap[p2];
    tick();
}

fluxe::Timer * fluxe::Timer::startInterval(int intervalMs, std::function<void(void)> tick)
{
    static unsigned int fluxeTimerId = 4721;
    unsigned int nextId = fluxeTimerId++;
    HWND win = nullptr;
    auto timerId = SetTimer(win, nextId, intervalMs, (TIMERPROC)FluxeTimerProc);
    winTimerMap[timerId] = tick;

    Timer * timer = new Timer();
    timer->timer = timerId;
    return timer;
}

void fluxe::Timer::stopTimer(fluxe::Timer * timer)
{
    HWND win = nullptr;
    KillTimer(win, timer->timer);
    winTimerMap.erase(timer->timer);
    timer->timer = 0;
    delete timer;
}

// bool fluxe::Timer::isRunning(fluxe::Timer * timer)
// {
//     return timer.timer != nullptr;
// } 
