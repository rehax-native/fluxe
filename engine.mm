#include "engine.h"
#include "shell/mac/platformWindow.h"
#include "shell/mac/canvasView.h"

CanvasView * globalView = nullptr;

fluxe::Engine::Engine()
{}

fluxe::Engine::~Engine()
{}

void * fluxe::Engine::createPlatformWindow()
{
  @autoreleasepool {
    void * window = OpenPlatformWindow();
    return window;
  }
}

void fluxe::Engine::closePlatformWindow(void * window)
{}

void fluxe::Engine::attachToPlatformWindow(void * platformWindow)
{
  @autoreleasepool {
    CanvasView * view = [CanvasView new];
    [view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    view.translatesAutoresizingMaskIntoConstraints = YES;
    
    NSTrackingAreaOptions options = (NSTrackingActiveAlways | NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved);
    NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:view.bounds
                                                        options:options
                                                          owner:view
                                                       userInfo:nil];
    [view addTrackingArea:area];

    this->view = (__bridge void *) view;
    
    NSWindow * win = (__bridge NSWindow *) platformWindow;
    [win setContentView:view];
    [win makeKeyAndOrderFront:NSApp];
    [view becomeFirstResponder];
  }
}

void fluxe::Engine::detachFromPlatformWindow()
{}

void fluxe::Engine::attachToPlatformView(void * platformView)
{
  @autoreleasepool {
    CanvasView * view = [CanvasView new];
    [view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    view.translatesAutoresizingMaskIntoConstraints = YES;
    
    NSTrackingAreaOptions options = (NSTrackingActiveAlways | NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved);
    NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:view.bounds
                                                        options:options
                                                          owner:view
                                                       userInfo:nil];
    [view addTrackingArea:area];

    this->view = (__bridge void *) view;
    
    NSView * providedView = (__bridge NSView *) platformView;
    [providedView addSubview:view];
    [view becomeFirstResponder];
  }
}

void fluxe::Engine::detachFromPlatformView()
{}

void fluxe::Engine::setNeedsRerender()
{
  NSView * view = (__bridge NSView *) this->view;
  [view setNeedsDisplay:true];
}

void fluxe::Engine::setRenderCallback(std::function<void(int, int, float, sk_sp<SkSurface> surface)> callback)
{
  CanvasView * view = (__bridge CanvasView *) this->view;
  view->renderCallback = callback;
  setNeedsRerender();
}

void fluxe::Engine::setMouseCallback(std::function<void(ShellMouseInstruction instruction)> callback)
{
  CanvasView * view = (__bridge CanvasView *) this->view;
  view->mouseCallback = callback;
}

void fluxe::Engine::setTextCallback(std::function<void(const char* str)> callback)
{
  CanvasView * view = (__bridge CanvasView *) this->view;
  view->textCallback = callback;
}

void fluxe::Engine::setKeyCallback(std::function<void(ShellKeyboardKeyInstruction)> callback)
{
  CanvasView * view = (__bridge CanvasView *) this->view;
  view->keyCallback = callback;
}

void fluxe::Engine::setMoveCallback(std::function<void(ShellKeyboardMoveInstruction)> callback)
{
  CanvasView * view = (__bridge CanvasView *) this->view;
  view->moveCallback = callback;
}

void fluxe::Engine::setCanHandleKeyboardCommandCallback(std::function<bool(ShellKeyboardCommand)> callback)
{
  CanvasView * view = (__bridge CanvasView *) this->view;
  view->canHandleKeyboardCommandCallback = callback;
}

void fluxe::Engine::setKeyboardCommandCallback(std::function<void(ShellKeyboardCommand)> callback)
{
  CanvasView * view = (__bridge CanvasView *) this->view;
  view->keyboardCommandCallback = callback;
}

// void fluxe::Engine::setClipboardCallback(std::function<void(ShellClipboardInstruction)> callback)
// {
//   CanvasView * view = (__bridge CanvasView *) this->view;
//   view->clipboardCallback = callback;
// }

void fluxe::Engine::startMainLoop()
{
  @autoreleasepool {
    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
    [NSApp run];
  }
}

void fluxe::Engine::stopMainLoop()
{
  [NSApp stop:NULL];
}

void fluxe::Engine::startEngine()
{}

void fluxe::Engine::stopEngine()
{}
