#import <Cocoa/Cocoa.h>
#import "platformView.h"
#include <functional>
#include "render_backend/skia/canvas.h"
#include "../callbacks.h"
#include <rehaxUtils/app/app.h>

@interface CanvasView : FluxePlatformView
{
  @public

  std::function<void(int, int, float, sk_sp<SkSurface> surface)> renderCallback;
  std::function<void(ShellMouseInstruction instruction)> mouseCallback;
  std::function<bool(ShellKeyboardCommand instruction)> canHandleKeyboardCommandCallback;
  std::function<void(ShellKeyboardCommand instruction)> keyboardCommandCallback;
  std::function<void(ShellKeyboardKeyInstruction instruction)> keyCallback;
  std::function<void(ShellKeyboardMoveInstruction instruction)> moveCallback;
  std::function<void(const char * str)> textCallback;
  // std::function<void(ShellClipboardInstruction instruction)> clipboardCallback;

  rehaxUtils::App::ApplicationThemeListenerId themeChangeListener;
}

- (void) drawRect: (NSRect) bounds;

@end
