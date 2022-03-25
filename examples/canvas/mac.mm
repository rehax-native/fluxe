#include "shell/mac/platformView.h"
#include "shell/mac/platformWindow.h"
#include "include/utils/mac/SkCGUtils.h"
#import <Cocoa/Cocoa.h>
#include "./canvasExample.cc"

@interface CanvasExampleView : FluxePlatformView
- (void) drawRect: (NSRect) bounds;
@end

@implementation CanvasExampleView
- (void) drawRect: (NSRect) bounds
{
  SkBitmap bmp = drawExample(self.bounds.size.width, self.bounds.size.height);
  //    CGContext* pCGContext = (CGContextRef) GetPlatformContext();
  CGContextRef pCGC = [NSGraphicsContext currentContext].CGContext;
  CGContext *pCGContext = [NSGraphicsContext graphicsContextWithCGContext: pCGC flipped: YES].CGContext;
  
  CGContextSaveGState(pCGContext);
  float screenScale = 2.0;
  //    CGContextScaleCTM(pCGContext, 1.0 / GetScreenScale(), 1.0 / GetScreenScale());
  CGContextScaleCTM(pCGContext, 1.0 / screenScale, 1.0 / screenScale);
  SkCGDrawBitmap(pCGContext, bmp, 0, 0);
  CGContextRestoreGState(pCGContext);
}
@end

int main() {
  @autoreleasepool {
    void * window = OpenPlatformWindow();
    
    NSView * view = [CanvasExampleView new];
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
