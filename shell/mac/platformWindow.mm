#include "platformWindow.h"
#include "platformView.h"

void* OpenPlatformWindow()
{
//  CloseWindow();
//  FluxePlatformView* pView = [[FluxePlatformView alloc] init];
// //   mView = (void*) pView;

// #ifdef FLUXE_USE_OPENGL
//  [[pView openGLContext] makeCurrentContext];
// #endif

// //   OnViewInitialized([pView layer]);
// //   SetScreenScale([[NSScreen mainScreen] backingScaleFactor]);
// //   GetDelegate()->LayoutUI(this);
// //   UpdateTooltips();
// //   GetDelegate()->OnUIOpen();

//  if (pParent)
//  {
//    [(NSView*) pParent addSubview: pView];
//  }

//  return mView;

    NSRect frame = NSMakeRect(200, 200, 600, 600);
    NSWindow* window = [[NSWindow alloc] initWithContentRect:frame
                        // styleMask: NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable | NSWindowStyleMaskUnifiedTitleAndToolbar | NSWindowStyleMaskFullSizeContentView
                        styleMask: NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable | NSWindowStyleMaskUnifiedTitleAndToolbar
                        backing:NSBackingStoreBuffered
                        defer:NO];
    [window makeKeyAndOrderFront:NSApp];
    return (__bridge void *) window;
}

//void IGraphicsMac::AttachPlatformView(const IRECT& r, void* pView)
//{
//  NSView* pNewSubView = (NSView*) pView;
//  [pNewSubView setFrame:ToNSRect(this, r)];
//
//  [(IGRAPHICS_VIEW*) mView addSubview:(NSView*) pNewSubView];
//}
//
//void IGraphicsMac::RemovePlatformView(void* pView)
//{
//  [(NSView*) pView removeFromSuperview];
//}
//
//void IGraphicsMac::CloseWindow()
//{
//  if (mView)
//  {
//    IGRAPHICS_VIEW* pView = (IGRAPHICS_VIEW*) mView;
//
//#ifdef IGRAPHICS_GL
//    [[pView openGLContext] makeCurrentContext];
//#endif
//
//    [pView removeAllToolTips];
//    [pView killTimer];
//    [pView removeFromSuperview];
//    [pView release];
//
//    mView = nullptr;
//    OnViewDestroyed();
//  }
//}
