#include "engine.h"
#include "shell/mac/platformWindow.h"
#include "shell/mac/platformView.h"

#include "third_party/skia/include/core/SkData.h"
#include "third_party/skia/include/core/SkImage.h"
#include "third_party/skia/include/core/SkBitmap.h"
#include "third_party/skia/include/core/SkSurface.h"
#include "include/utils/mac/SkCGUtils.h"

fluxe::Canvas * globalCanvas = nullptr;
std::function<sk_sp<fluxe::Surface>(int, int)> globalCallback;

// TODO need to clean this up
// this isn't supposed to be here
@interface CanvasView : FluxePlatformView
- (void) drawRect: (NSRect) bounds;
@end

@implementation CanvasView
- (void) drawRect: (NSRect) bounds
{
  // if (globalCanvas == nullptr) {
  //   return;
  // }
  
  sk_sp<fluxe::Surface> rasterSurface = globalCallback(bounds.size.width, bounds.size.height);

//  auto width = self.bounds.size.width;
//  auto height = self.bounds.size.height;
//
////  sk_sp<SkSurface> rasterSurface = SkSurface::MakeRasterN32Premul(width, height);
////  SkCanvas* rasterCanvas = rasterSurface->getCanvas();
//
 SkPixmap pixmap;
 rasterSurface->peekPixels(&pixmap);
 SkBitmap bmp;
 bmp.installPixels(pixmap);

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

CanvasView * globalView = nullptr;


fluxe::Engine::Engine()
{}

fluxe::Engine::~Engine()
{}

void * fluxe::Engine::createPlatformWindow()
{
  void * window = OpenPlatformWindow();
  return window;
}

void fluxe::Engine::closePlatformWindow(void * window)
{}

void fluxe::Engine::attachToPlatformWindow(void * platformWindow)
{
  CanvasView * view = [CanvasView new];
  [view setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
  view.translatesAutoresizingMaskIntoConstraints = YES;

  globalView = view;
  
  NSWindow * win = (__bridge NSWindow *) platformWindow;
  [win setContentView:view];
  [win makeKeyAndOrderFront:NSApp];
}

void fluxe::Engine::detachFromPlatformWindow()
{}

// void fluxe::Engine::renderCanvas(Canvas * canvas)
// {
//   globalCanvas = canvas;
//   globalView.needsDisplay = YES;
// }
void fluxe::Engine::setRenderCallback(std::function<sk_sp<fluxe::Surface>(int, int)> callback)
{
  globalCallback = callback;
}

void fluxe::Engine::startMainLoop()
{
  [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
  [NSApp run];
}

void fluxe::Engine::stopMainLoop()
{
  [NSApp stop:NULL];
}

void fluxe::Engine::startEngine()
{}

void fluxe::Engine::stopEngine()
{}
