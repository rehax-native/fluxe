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
std::function<void(float left, float top, int button)> mouseDownCallback;
std::function<void(float left, float top, int button)> mouseUpCallback;
std::function<void(float left, float top)> mouseMoveCallback;
std::function<void(const char * str)> textCallback;
std::function<void(int code)> keyDownCallback;
std::function<void(int code)> keyUpCallback;
std::function<void(bool select)> moveLeftCallback;
std::function<void(bool select)> moveRightCallback;
std::function<void(bool select)> moveWordLeftCallback;
std::function<void(bool select)> moveWordRightCallback;
std::function<void(bool select)> moveBackwardCallback;
std::function<void(bool select)> moveForwardCallback;
std::function<void(void)> deleteBackwardCallback;
std::function<void(void)> deleteForwardCallback;
std::function<void(void)> selectAllCallback;

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
  //  float screenScale = 1.0;
  //    CGContextScaleCTM(pCGContext, 1.0 / GetScreenScale(), 1.0 / GetScreenScale());
  CGContextScaleCTM(pCGContext, 1.0 / screenScale, 1.0 / screenScale);
  SkCGDrawBitmap(pCGContext, bmp, 0, 0);
  CGContextRestoreGState(pCGContext);
}

- (void)mouseDown:(NSEvent *)theEvent
{
  NSPoint curPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
  mouseDownCallback(curPoint.x, curPoint.y, 0);
}

- (void)mouseDragged:(NSEvent *)theEvent
{
  NSPoint curPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
  mouseMoveCallback(curPoint.x, curPoint.y);
}

- (void)mouseMoved:(NSEvent *)theEvent
{
  NSPoint curPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
  mouseMoveCallback(curPoint.x, curPoint.y);
}
 
- (void)mouseUp:(NSEvent *)theEvent
{
  NSPoint curPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
  mouseUpCallback(curPoint.x, curPoint.y, 0);
}

- (BOOL)acceptsFirstResponder {
  return YES;
}

- (void)keyDown:(NSEvent *)theEvent {
  [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
  if ([@"a" isEqualToString:theEvent.characters] && theEvent.modifierFlags & NSEventModifierFlagCommand) {
    selectAllCallback();
  }
}

- (void)keyUp:(NSEvent *)theEvent {
}

- (void)insertText:(NSString *)string { textCallback([string UTF8String]); }
- (void)moveForward:(nullable id)sender { moveForwardCallback(false); }
- (void)moveRight:(nullable id)sender { moveRightCallback(false); }
- (void)moveBackward:(nullable id)sender { moveBackwardCallback(false); }
- (void)moveLeft:(nullable id)sender { moveLeftCallback(false); }

//- (void)moveUp:(nullable id)sender;
//- (void)moveDown:(nullable id)sender;
//- (void)moveWordForward:(nullable id)sender;
//- (void)moveWordBackward:(nullable id)sender;
//- (void)moveToBeginningOfLine:(nullable id)sender;
//- (void)moveToEndOfLine:(nullable id)sender;
//- (void)moveToBeginningOfParagraph:(nullable id)sender;
//- (void)moveToEndOfParagraph:(nullable id)sender;
//- (void)moveToEndOfDocument:(nullable id)sender;
//- (void)moveToBeginningOfDocument:(nullable id)sender;
//- (void)pageDown:(nullable id)sender;
//- (void)pageUp:(nullable id)sender;
//- (void)centerSelectionInVisibleArea:(nullable id)sender;
//
- (void)moveBackwardAndModifySelection:(nullable id)sender { NSLog(@"x1"); }
- (void)moveForwardAndModifySelection:(nullable id)sender { NSLog(@"x2"); }
- (void)moveWordForwardAndModifySelection:(nullable id)sender { NSLog(@"y1"); }
- (void)moveWordBackwardAndModifySelection:(nullable id)sender { NSLog(@"y2"); }
//- (void)moveUpAndModifySelection:(nullable id)sender;
//- (void)moveDownAndModifySelection:(nullable id)sender;
//
//- (void)moveToBeginningOfLineAndModifySelection:(nullable id)sender;
//- (void)moveToEndOfLineAndModifySelection:(nullable id)sender;
//- (void)moveToBeginningOfParagraphAndModifySelection:(nullable id)sender;
- (void)moveToEndOfParagraphAndModifySelection:(nullable id)sender { NSLog(@"enlkx"); } 
- (void)moveToEndOfDocumentAndModifySelection:(nullable id)sender { NSLog(@"enlk"); }
//- (void)moveToBeginningOfDocumentAndModifySelection:(nullable id)sender;
//- (void)pageDownAndModifySelection:(nullable id)sender;
//- (void)pageUpAndModifySelection:(nullable id)sender;
//- (void)moveParagraphForwardAndModifySelection:(nullable id)sender;
//- (void)moveParagraphBackwardAndModifySelection:(nullable id)sender;
//
- (void)moveWordRight:(nullable id)sender { moveWordRightCallback(false); }
- (void)moveWordLeft:(nullable id)sender { moveWordLeftCallback(false); }
- (void)moveRightAndModifySelection:(nullable id)sender { moveRightCallback(true); } // this works
- (void)moveLeftAndModifySelection:(nullable id)sender { moveLeftCallback(true); } // this works
- (void)moveWordRightAndModifySelection:(nullable id)sender { moveWordRightCallback(true); } // this works
- (void)moveWordLeftAndModifySelection:(nullable id)sender { moveWordLeftCallback(true); } // this works
//
//- (void)moveToLeftEndOfLine:(nullable id)sender API_AVAILABLE(macos(10.6));
//- (void)moveToRightEndOfLine:(nullable id)sender API_AVAILABLE(macos(10.6));
//- (void)moveToLeftEndOfLineAndModifySelection:(nullable id)sender API_AVAILABLE(macos(10.6));
//- (void)moveToRightEndOfLineAndModifySelection:(nullable id)sender API_AVAILABLE(macos(10.6));
//
//- (void)scrollPageUp:(nullable id)sender;
//- (void)scrollPageDown:(nullable id)sender;
//- (void)scrollLineUp:(nullable id)sender;
//- (void)scrollLineDown:(nullable id)sender;
//
//- (void)scrollToBeginningOfDocument:(nullable id)sender;
//- (void)scrollToEndOfDocument:(nullable id)sender;
//
//    /* Graphical Element transposition */
//
//- (void)transpose:(nullable id)sender;
//- (void)transposeWords:(nullable id)sender;
//
//    /* Selections */
//
- (void)selectAll:(nullable id)sender {
  selectAllCallback();
}
- (void)selectParagraph:(nullable id)sender {
  NSLog(@"SEL AL");
  selectAllCallback();
}
- (void)selectLine:(nullable id)sender {
  NSLog(@"SEL LINE");
}
- (void)selectWord:(nullable id)sender {
  NSLog(@"SEL WORD");
}

//    /* Insertions and Indentations */
//
//- (void)indent:(nullable id)sender;
//- (void)insertTab:(nullable id)sender;
//- (void)insertBacktab:(nullable id)sender;
//- (void)insertNewline:(nullable id)sender;
//- (void)insertParagraphSeparator:(nullable id)sender;
//- (void)insertNewlineIgnoringFieldEditor:(nullable id)sender;
//- (void)insertTabIgnoringFieldEditor:(nullable id)sender;
//- (void)insertLineBreak:(nullable id)sender;
//- (void)insertContainerBreak:(nullable id)sender;
//- (void)insertSingleQuoteIgnoringSubstitution:(nullable id)sender API_AVAILABLE(macos(10.5));
//- (void)insertDoubleQuoteIgnoringSubstitution:(nullable id)sender API_AVAILABLE(macos(10.5));
//
//    /* Case changes */
//
//- (void)changeCaseOfLetter:(nullable id)sender;
//- (void)uppercaseWord:(nullable id)sender;
//- (void)lowercaseWord:(nullable id)sender;
//- (void)capitalizeWord:(nullable id)sender;
//
//    /* Deletions */
//
- (void)deleteForward:(nullable id)sender {
  deleteForwardCallback(); 
}
- (void)deleteBackward:(nullable id)sender {
  deleteBackwardCallback();
}
//- (void)deleteBackwardByDecomposingPreviousCharacter:(nullable id)sender;
//- (void)deleteWordForward:(nullable id)sender;
//- (void)deleteWordBackward:(nullable id)sender;
//- (void)deleteToBeginningOfLine:(nullable id)sender;
//- (void)deleteToEndOfLine:(nullable id)sender;
//- (void)deleteToBeginningOfParagraph:(nullable id)sender;
//- (void)deleteToEndOfParagraph:(nullable id)sender;

- (void)yank:(nullable id)sender {
  NSLog(@"YANK");
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
  
  NSTrackingAreaOptions options = (NSTrackingActiveAlways | NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved);
  NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:view.bounds
                                                      options:options
                                                        owner:view
                                                     userInfo:nil];
  [view addTrackingArea:area];

  globalView = view;
  
  NSWindow * win = (__bridge NSWindow *) platformWindow;
  [win setContentView:view];
  [win makeKeyAndOrderFront:NSApp];
  [view becomeFirstResponder];
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

void fluxe::Engine::setNeedsRerender()
{
  globalView.needsDisplay = YES;
}

void fluxe::Engine::setMouseDownCallback(std::function<void(float left, float top, int button)> callback)
{
  mouseDownCallback = callback;
}
void fluxe::Engine::setMouseUpCallback(std::function<void(float left, float top, int button)> callback)
{
  mouseUpCallback = callback;
}
void fluxe::Engine::setMouseMoveCallback(std::function<void(float left, float top)> callback)
{
  mouseMoveCallback = callback;
}

void fluxe::Engine::setKeyDownCallback(std::function<void(int code)> callback)
{
  keyDownCallback = callback;
}

void fluxe::Engine::setKeyUpCallback(std::function<void(int code)> callback)
{
  keyUpCallback = callback;
}

void fluxe::Engine::setTextCallback(std::function<void(const char *)> callback)
{
  textCallback = callback;
}

void fluxe::Engine::setMoveLeftCallback(std::function<void(bool select)> callback) { moveLeftCallback = callback; }
void fluxe::Engine::setMoveRightCallback(std::function<void(bool select)> callback) { moveRightCallback = callback; }
void fluxe::Engine::setMoveWordLeftCallback(std::function<void(bool select)> callback) { moveWordLeftCallback = callback; }
void fluxe::Engine::setMoveWordRightCallback(std::function<void(bool select)> callback) { moveWordRightCallback = callback; }
void fluxe::Engine::setMoveBackwardCallback(std::function<void(bool select)> callback) { moveBackwardCallback = callback; }
void fluxe::Engine::setMoveForwardCallback(std::function<void(bool select)> callback) { moveForwardCallback = callback; }
void fluxe::Engine::setDeleteBackwardCallback(std::function<void(void)> callback) { deleteBackwardCallback = callback; }
void fluxe::Engine::setDeleteForwardCallback(std::function<void(void)> callback) { deleteForwardCallback = callback; }
void fluxe::Engine::setSelectAllCallback(std::function<void(void)> callback) { selectAllCallback = callback; }

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
