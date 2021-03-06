#import <Cocoa/Cocoa.h>
#import "platformView.h"
#include <functional>
#include "render_backend/skia/canvas.h"
#include "../callbacks.h"

@interface CanvasView : FluxePlatformView
{
  @public

  std::function<sk_sp<fluxe::Surface>(int, int, float)> renderCallback;
  std::function<void(ShellMouseInstruction instruction)> mouseCallback;
  std::function<void(ShellKeyboardKeyInstruction instruction)> keyCallback;
  std::function<void(ShellKeyboardMoveInstruction instruction)> moveCallback;
  std::function<void(const char * str)> textCallback;
}

- (void) drawRect: (NSRect) bounds;

@end
