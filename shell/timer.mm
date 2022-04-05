#include "timer.h"
#import <Foundation/Foundation.h>

fluxe::Timer * fluxe::Timer::startInterval(int intervalMs, std::function<void(void)> tick)
{
  NSTimer * nativeTimer = [NSTimer scheduledTimerWithTimeInterval:(float)intervalMs / 1000.0
                                                          repeats:YES
                                                            block:^ (NSTimer *timer) {
    tick();
  }];
    Timer * timer = new Timer();
    timer->timer = nativeTimer;
    return timer;
}

void fluxe::Timer::stopTimer(fluxe::Timer * timer)
{
    [timer->timer invalidate];
    timer->timer = nullptr;
    delete timer;
}

// bool fluxe::Timer::isRunning(fluxe::Timer * timer)
// {
//     return timer.timer != nullptr;
// }