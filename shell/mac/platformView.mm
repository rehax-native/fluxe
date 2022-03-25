#import "platformView.h"

@implementation FluxePlatformView

- (id) init
{
  float width = 200;
  float height = 200;

  NSRect r = NSMakeRect(0.f, 0.f, width, height);
  self = [super initWithFrame:r];

  self.wantsLayer = YES;
  self.layer.opaque = YES;
  self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawDuringViewResize;
  
  #if defined FLUXE_USE_METAL
    self.layer = [CAMetalLayer new];
    [(CAMetalLayer*)[self layer] setPixelFormat:MTLPixelFormatBGRA8Unorm];
    ((CAMetalLayer*) self.layer).device = MTLCreateSystemDefaultDevice();
    
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
  [super dealloc];
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
  
  // mGraphics->SetPlatformContext(nullptr);
  
  // if (newScale != mGraphics->GetScreenScale())
  //   mGraphics->SetScreenScale(newScale);

  #if defined FLUXE_USE_OPENGL
    self.layer.contentsScale = 1./newScale;
  #elif defined FLUXE_USE_METAL
    [(CAMetalLayer*)[self layer] setDrawableSize:CGSizeMake(self.frame.size.width * newScale, self.frame.size.height * newScale)];
  #endif
}

// - (CGContextRef) getCGContextRef
// {
//   CGContextRef pCGC = [NSGraphicsContext currentContext].CGContext;
//   return [NSGraphicsContext graphicsContextWithCGContext: pCGC flipped: YES].CGContext;
// }

// not called for layer backed views
- (void) drawRect: (NSRect) bounds
{
  #if !defined FLUXE_USE_OPENGL && !defined FLUXE_USE_METAL
  // if (mGraphics)
  // {
  //   mGraphics->SetPlatformContext([self getCGContextRef]);
      
  //   if (mGraphics->GetPlatformContext())
  //   {
  //     const NSRect *rects;
  //     NSInteger numRects;
  //     [self getRectsBeingDrawn:&rects count:&numRects];
  //     IRECTList drawRects;

  //     for (int i = 0; i < numRects; i++)
  //       drawRects.Add(ToIRECT(mGraphics, &rects[i]));
      
  //     mGraphics->Draw(drawRects);
  //   }
  // }
  #else // this gets called on resize
  //TODO: set GL context/flush?
  //mGraphics->Draw(mDirtyRects);
  #endif
}

- (void) render
{
  // mDirtyRects.Clear();
  
  // if (mGraphics->IsDirty(mDirtyRects))
  // {
  //   mGraphics->SetAllControlsClean();
      
  //   #if !defined IGRAPHICS_GL && !defined IGRAPHICS_METAL // for layer-backed views setNeedsDisplayInRect/drawRect is not called
  //     for (int i = 0; i < mDirtyRects.Size(); i++)
  //       [self setNeedsDisplayInRect:ToNSRect(mGraphics, mDirtyRects.Get(i))];
  //   #else
  //     #ifdef IGRAPHICS_GL
  //       [[self openGLContext] makeCurrentContext];
  //     #endif
  //     // so just draw on each frame, if something is dirty
  //     mGraphics->Draw(mDirtyRects);
  //   #endif
  //   #ifdef IGRAPHICS_GL
  //   [[self openGLContext] flushBuffer];
  //   #endif
  // }
}

@end
