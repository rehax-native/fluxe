#include "shell/mac/platformView.h"
#include "shell/mac/platformWindow.h"
#import <Cocoa/Cocoa.h>

int main() {
  @autoreleasepool {
    void * window = OpenPlatformWindow();
    
    NSView * view = [FluxePlatformView new];
    [view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    view.translatesAutoresizingMaskIntoConstraints = YES;

    NSWindow * win = (__bridge NSWindow *) window;
    [win setContentView:view];

    [win makeKeyAndOrderFront:NSApp];
    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
    [NSApp run];
  }
  return 0;
}
