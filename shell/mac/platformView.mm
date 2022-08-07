#import "platformView.h"
#include "tools/skottie_ios_app/SkMetalViewBridge.h"
#include "include/gpu/mtl/GrMtlBackendContext.h"

@implementation FluxePlatformView
#if defined FLUXE_USE_METALKIT
{
    sk_sp<GrDirectContext> fgrContext;
}
#endif

- (id) init
{
  float width = 200;
  float height = 200;

  NSRect r = NSMakeRect(0.f, 0.f, width, height);
  self = [super initWithFrame:r];

  self.wantsLayer = YES;
  self.layer.opaque = YES;
  self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawDuringViewResize;
  
  #if defined FLUXE_USE_METALKIT
    self.metalDevice = MTLCreateSystemDefaultDevice();
    self.device = self.metalDevice;
    self.metalQueue = [[self device] newCommandQueue];
    
    GrContextOptions options;
    GrMtlBackendContext backendContext = {};
    backendContext.fDevice.reset(self.device);
    backendContext.fQueue.reset(self.metalQueue);
    fgrContext = GrDirectContext::MakeMetal(backendContext, options);
    
    self.grContext = fgrContext.get();
    SkMtkViewConfigForSkia(self);

    self.paused = true;
    self.enableSetNeedsDisplay = true;
    [self setNeedsDisplay:true];
    
  #elif defined FLUXE_USE_OPENGL
    NSOpenGLPixelFormatAttribute profile = NSOpenGLProfileVersionLegacy;
    #if defined FLUXE_USE_OPENGL_3
      profile = (NSOpenGLPixelFormatAttribute)NSOpenGLProfileVersion3_2Core;
    #endif
    const NSOpenGLPixelFormatAttribute attrs[] =  {
      NSOpenGLPFAAccelerated,
      NSOpenGLPFANoRecovery,
      NSOpenGLPFADoubleBuffer,
      NSOpenGLPFAAlphaSize, 8,
      NSOpenGLPFAColorSize, 24,
      NSOpenGLPFADepthSize, 0,
      NSOpenGLPFAStencilSize, 8,
      NSOpenGLPFAOpenGLProfile, profile,
      (NSOpenGLPixelFormatAttribute) 0
    };
    NSOpenGLPixelFormat* pPixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
    NSOpenGLContext* pGLContext = [[NSOpenGLContext alloc] initWithFormat:pPixelFormat shareContext:nil];

    self.pixelFormat = pPixelFormat;
    self.openGLContext = pGLContext;
    self.wantsBestResolutionOpenGLSurface = YES;
  #endif

  return self;
}

#ifdef FLUXE_USE_OPENGL
- (void) prepareOpenGL
{
  [super prepareOpenGL];
  
  [[self openGLContext] makeCurrentContext];
  
  // Synchronize buffer swaps with vertical refresh rate
  GLint swapInt = 1;
  [[self openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
  
  [self setTimer];
}
#endif

- (void) dealloc
{
  if ([NSColorPanel sharedColorPanelExists]) {
    [[NSColorPanel sharedColorPanel] close];
  }
  
//  mColorPickerFunc = nullptr;
//  [mMoveCursor release];
//  [mTrackingArea release];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  // [super dealloc];
}

- (BOOL) isFlipped
{
  return YES;
}

- (void) viewDidChangeBackingProperties:(NSNotification*) pNotification
{
  NSWindow* pWindow = [self window];
  
  if (!pWindow) {
    return;
  }
  
  CGFloat newScale = [pWindow backingScaleFactor];

  #if defined FLUXE_USE_OPENGL
    self.layer.contentsScale = 1./newScale;
  #elif defined FLUXE_USE_METALKIT
    [(CAMetalLayer*)[self layer] setDrawableSize:CGSizeMake(self.frame.size.width * newScale, self.frame.size.height * newScale)];
  #endif
}

 - (CGContextRef) getCGContextRef
 {
   CGContextRef pCGC = [NSGraphicsContext currentContext].CGContext;
   return [NSGraphicsContext graphicsContextWithCGContext: pCGC flipped: YES].CGContext;
 }

// not called for layer backed views
- (void) drawRect: (NSRect) bounds
{
  #if !defined FLUXE_USE_OPENGL && !defined FLUXE_USE_METALKIT
//   if (mGraphics)
//   {
//     mGraphics->SetPlatformContext([self getCGContextRef]);
//      
//     if (mGraphics->GetPlatformContext())
//     {
//       const NSRect *rects;
//       NSInteger numRects;
//       [self getRectsBeingDrawn:&rects count:&numRects];
//       IRECTList drawRects;
//
//       for (int i = 0; i < numRects; i++)
//         drawRects.Add(ToIRECT(mGraphics, &rects[i]));
//      
//       mGraphics->Draw(drawRects);
//     }
//   }
  #else // this gets called on resize
  //TODO: set GL context/flush?
  //mGraphics->Draw(mDirtyRects);
  #endif
}

@end
