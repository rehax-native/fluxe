#pragma once

#include <functional>

#if __OBJC__
@class NSTimer;
#else
typedef void NSTimer;
#endif

namespace fluxe {

class Timer {
public:
    static Timer * startInterval(int intervalMs, std::function<void(void)> tick);
    static void stopTimer(Timer * timer);
    // static bool isRunning(Timer * timer);
private:
    NSTimer * timer;
};

}
