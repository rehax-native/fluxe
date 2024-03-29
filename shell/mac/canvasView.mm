#import "canvasView.h"
#include "include/core/SkData.h"
#include "include/core/SkImage.h"
#include "include/core/SkBitmap.h"
#include "include/core/SkSurface.h"
#include "include/utils/mac/SkCGUtils.h"
#include "include/gpu/GrBackendSurface.h"
#include "include/gpu/GrDirectContext.h"
#include "include/gpu/mtl/GrMtlTypes.h"
#include "tools/skottie_ios_app/SkMetalViewBridge.h"

@implementation CanvasView

- (id) init
{
  self = [super init];
  if (self) {
    [self registerForDraggedTypes:@[
      NSPasteboardTypeString,
      NSPasteboardTypeTabularText,
      NSPasteboardTypeURL,
      NSPasteboardTypeFileURL
    ]];
    
    themeChangeListener = rehaxUtils::App::addApplicationThemeChangeListener([self] (rehaxUtils::App::ApplicationTheme theme) {
      [self setNeedsDisplay:YES];
    });
  }
  return self;
}

-(void)dealloc
{
  rehaxUtils::App::removeApplicationThemeChangeListener(themeChangeListener);
  [super dealloc];
}

- (void) drawRect: (NSRect) bounds
{
  @autoreleasepool {
    [super drawRect:bounds];
      
#if defined FLUXE_USE_METALKIT
    if (![self grContext]) {
      return;
    }
      
    float screenScale = self.window.screen.backingScaleFactor;
    sk_sp<SkSurface> surface = SkMtkViewToSurface(self, [self grContext]);
    renderCallback(self.bounds.size.width, self.bounds.size.height, screenScale, surface);

    SkPixmap pixmap;
    surface->peekPixels(&pixmap);
    SkBitmap bmp;
    bmp.installPixels(pixmap);
      
    surface->flushAndSubmit();
    surface = nullptr;
    id<MTLCommandBuffer> commandBuffer = [[self metalQueue] commandBuffer];
    [commandBuffer presentDrawable:[self currentDrawable]];
    [commandBuffer commit];
#else
    float screenScale = self.window.screen.backingScaleFactor;
    sk_sp<SkSurface> surface = fluxe::Surface::MakeRasterN32Premul(bounds.size.width * screenScale, bounds.size.height * screenScale);
    renderCallback(bounds.size.width, bounds.size.height, screenScale, surface);

    SkPixmap pixmap;
    surface->peekPixels(&pixmap);
    SkBitmap bmp;
    bmp.installPixels(pixmap);

    CGContextRef context = [self getCGContextRef];
    CGContextSaveGState(context);
    CGContextScaleCTM(context, 1.0 / screenScale, 1.0 / screenScale);
    SkCGDrawBitmap(context, bmp, 0, 0);
    CGContextRestoreGState(context);
#endif
  }
}

- (BOOL)acceptsFirstResponder {
  return YES;
}

#pragma mark Mouse Events

- (void)mouseDown:(NSEvent *)theEvent
{
  @autoreleasepool {
    NSPoint curPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    mouseCallback({
      .left = (float) curPoint.x,
      .top = (float) curPoint.y,
      .button = (int) theEvent.buttonNumber,
      .isDown = true,
    });
  }
}

- (void)rightMouseDown:(NSEvent *)theEvent
{
  @autoreleasepool {
    NSPoint curPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    mouseCallback({
      .left = (float) curPoint.x,
      .top = (float) curPoint.y,
      .button = (int) theEvent.buttonNumber,
      .isDown = true,
    });
  }
}

- (void)mouseDragged:(NSEvent *)theEvent
{
  @autoreleasepool {
    NSPoint curPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    mouseCallback({
      .left = (float) curPoint.x,
      .top = (float) curPoint.y,
      .button = (int) theEvent.buttonNumber,
      .isMove = true,
      .isDown = true,
    });
  }
}

- (void)mouseMoved:(NSEvent *)theEvent
{
  @autoreleasepool {
    NSPoint curPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    mouseCallback({
      .left = (float) curPoint.x,
      .top = (float) curPoint.y,
      .isMove = true,
    });
  }
}
 
- (void)mouseUp:(NSEvent *)theEvent
{
  @autoreleasepool {
    NSPoint curPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    mouseCallback({
      .left = (float) curPoint.x,
      .top = (float) curPoint.y,
      .button = (int) theEvent.buttonNumber,
      .isUp = true,
    });
  }
}

- (void)rightMouseUp:(NSEvent *)theEvent
{
  @autoreleasepool {
    NSPoint curPoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    mouseCallback({
      .left = (float) curPoint.x,
      .top = (float) curPoint.y,
      .button = (int) theEvent.buttonNumber,
      .isUp = true,
    });
  }
}

#pragma mark Key Events

- (void)keyDown:(NSEvent *)theEvent {
  @autoreleasepool {
    keyCallback({
      .code = theEvent.keyCode,
      .isDown = true,
    });

    ShellKeyboardCommand command {
      .commandKey = std::string(theEvent.characters.UTF8String),

      .isWithShiftModifier = (theEvent.modifierFlags & NSEventModifierFlagShift) > 0,
      .isWithCmdCtrlModifier = (theEvent.modifierFlags & NSEventModifierFlagCommand) > 0,

      .isWithMacControlModifier = (theEvent.modifierFlags & NSEventModifierFlagControl) > 0,
      .isWithMacOptionModifier = (theEvent.modifierFlags & NSEventModifierFlagOption) > 0,
      .isWithMacCommandModifier = (theEvent.modifierFlags & NSEventModifierFlagCommand) > 0,

     .isWitWinControlModifier = false,
     .isWitWinAltModifier = false,
     .isWitWinWinModifier = false,
    };
    if (canHandleKeyboardCommandCallback(command)) {
      keyboardCommandCallback(command);
    } else {
      [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
    }
  }
}

- (void)keyUp:(NSEvent *)theEvent {
  @autoreleasepool {
    keyCallback({
      .code = theEvent.keyCode,
      .isUp = true,
    });
  }
}

- (void)insertText:(NSString *)string { textCallback([string UTF8String]); }

#pragma mark Move Events

- (void)moveForward:(nullable id)sender
{
  moveCallback({
    .isForwards = true,
  });
}

- (void)moveBackward:(nullable id)sender
{
  moveCallback({
    .isBackwards = true,
  });
}

- (void)moveRight:(nullable id)sender
{
  moveCallback({
    .isRight = true,
  });
}

- (void)moveLeft:(nullable id)sender
{
  moveCallback({
    .isLeft = true,
  });
}

- (void)moveUp:(nullable id)sender
{
  moveCallback({
    .isUp = true,
  });
}

- (void)moveDown:(nullable id)sender
{
  moveCallback({
    .isDown = true,
  });
}

- (void)moveWordForward:(nullable id)sender
{
  moveCallback({
    .isForwards = true,
    .isWord = true,
  });
}

- (void)moveWordBackward:(nullable id)sender
{
  moveCallback({
    .isBackwards = true,
    .isWord = true,
  });
}

- (void)moveToBeginningOfLine:(nullable id)sender
{
  moveCallback({
    .isLine = true,
    .isBackwards = true,
  });
}

- (void)moveToEndOfLine:(nullable id)sender
{
  moveCallback({
    .isLine = true,
    .isForwards = true,
  });
}

- (void)moveToBeginningOfParagraph:(nullable id)sender
{
  moveCallback({
    .isParagraph = true,
    .isBackwards = true,
  });
}

- (void)moveToEndOfParagraph:(nullable id)sender
{
  moveCallback({
    .isParagraph = true,
    .isForwards = true,
  });
}

- (void)moveToEndOfDocument:(nullable id)sender
{
  moveCallback({
    .isDocument = true,
    .isForwards = true,
  });
}

- (void)moveToBeginningOfDocument:(nullable id)sender
{
  moveCallback({
    .isDocument = true,
    .isBackwards = true,
  });
}

- (void)pageDown:(nullable id)sender
{
  moveCallback({
    .isPage = true,
    .isDown = true,
  });
}

- (void)pageUp:(nullable id)sender
{
  moveCallback({
    .isPage = true,
    .isUp = true,
  });
}

- (void)centerSelectionInVisibleArea:(nullable id)sender
{
//  moveCallback({
//
//  });
}

- (void)moveBackwardAndModifySelection:(nullable id)sender
{
  moveCallback({
    .isBackwards = true,
    .isSelect = true,
  });
}

- (void)moveForwardAndModifySelection:(nullable id)sender
{
  moveCallback({
    .isForwards = true,
    .isSelect = true,
  });
}

- (void)moveWordBackwardAndModifySelection:(nullable id)sender
{
  moveCallback({
    .isBackwards = true,
    .isWord = true,
    .isSelect = true,
  });
}

- (void)moveWordForwardAndModifySelection:(nullable id)sender
{
  moveCallback({
    .isForwards = true,
    .isWord = true,
    .isSelect = true,
  });
}

- (void)moveUpAndModifySelection:(nullable id)sender
{
  moveCallback({
    .isUp = true,
    .isSelect = true,
  });
}

- (void)moveDownAndModifySelection:(nullable id)sender
{
  moveCallback({
    .isDown = true,
    .isSelect = true,
  });
}

- (void)moveToBeginningOfLineAndModifySelection:(nullable id)sender
{
  moveCallback({
    .isBackwards = true,
    .isLine = true,
    .isSelect = true,
  });
}

- (void)moveToEndOfLineAndModifySelection:(nullable id)sender
{
  moveCallback({
    .isForwards = true,
    .isLine = true,
    .isSelect = true,
  });
}

- (void)moveToBeginningOfParagraphAndModifySelection:(nullable id)sender
{
  moveCallback({
    .isBackwards = true,
    .isParagraph = true,
    .isSelect = true,
  });
}

- (void)moveToEndOfParagraphAndModifySelection:(nullable id)sender
{
  moveCallback({
    .isForwards = true,
    .isParagraph = true,
    .isSelect = true,
  });
}

- (void)moveToEndOfDocumentAndModifySelection:(nullable id)sender
{
  moveCallback({
    .isForwards = true,
    .isDocument = true,
    .isSelect = true,
  });
}

- (void)moveToBeginningOfDocumentAndModifySelection:(nullable id)sender
{
  moveCallback({
    .isBackwards = true,
    .isDocument = true,
    .isSelect = true,
  });
}

- (void)pageDownAndModifySelection:(nullable id)sender
{
  moveCallback({
    .isDown = true,
    .isPage = true,
    .isSelect = true,
  });
}

- (void)pageUpAndModifySelection:(nullable id)sender
{
  moveCallback({
    .isUp = true,
    .isPage = true,
    .isSelect = true,
  });
}

- (void)moveParagraphForwardAndModifySelection:(nullable id)sender
{
  // moveCallback({
  //   .isForwards = true,
  //   .isParagraph = true,
  //   .isSelect = true,
  // });
}

- (void)moveParagraphBackwardAndModifySelection:(nullable id)sender
{
  // moveCallback({
  //   .isBackwards = true,
  //   .isParagraph = true,
  //   .isSelect = true,
  // });
}

- (void)moveWordRight:(nullable id)sender
{
  moveCallback({
    .isWord = true,
    .isRight = true,
  });
}

- (void)moveWordLeft:(nullable id)sender
{
  moveCallback({
    .isWord = true,
    .isLeft = true,
  });
}

- (void)moveRightAndModifySelection:(nullable id)sender
{
  moveCallback({
    .isRight = true,
    .isSelect = true,
  });
}

- (void)moveLeftAndModifySelection:(nullable id)sender
{
  moveCallback({
    .isLeft = true,
    .isSelect = true,
  });
}

- (void)moveWordRightAndModifySelection:(nullable id)sender
{
  moveCallback({
    .isRight = true,
    .isWord = true,
    .isSelect = true,
  });
}

- (void)moveWordLeftAndModifySelection:(nullable id)sender
{
  moveCallback({
    .isLeft = true,
    .isWord = true,
    .isSelect = true,
  });
}

- (void)moveToLeftEndOfLine:(nullable id)sender
{
  moveCallback({
    .isLine = true,
    .isLeft = true,
  });
}

- (void)moveToRightEndOfLine:(nullable id)sender
{
  moveCallback({
    .isLine = true,
    .isRight = true,
  });
}

- (void)moveToLeftEndOfLineAndModifySelection:(nullable id)sender
{
  moveCallback({
    .isLine = true,
    .isLeft = true,
    .isSelect = true,
  });
}

- (void)moveToRightEndOfLineAndModifySelection:(nullable id)sender
{
  moveCallback({
    .isLine = true,
    .isRight = true,
    .isSelect = true,
  });
}

- (void)scrollPageUp:(nullable id)sender
{
  moveCallback({
    .isPage = true,
    .isUp = true,
    .isScroll = true,
  });
}

- (void)scrollPageDown:(nullable id)sender
{
  moveCallback({
    .isPage = true,
    .isDown = true,
    .isScroll = true,
  });
}

- (void)scrollLineUp:(nullable id)sender
{
  moveCallback({
    .isLine = true,
    .isUp = true,
    .isScroll = true,
  });
}

- (void)scrollLineDown:(nullable id)sender
{
  moveCallback({
    .isLine = true,
    .isDown = true,
    .isScroll = true,
  });
}

- (void)scrollToBeginningOfDocument:(nullable id)sender
{
  moveCallback({
    .isBackwards = true,
    .isDocument = true,
    .isScroll = true,
  });
}

- (void)scrollToEndOfDocument:(nullable id)sender
{
  moveCallback({
    .isForwards = true,
    .isDocument = true,
    .isScroll = true,
  });
}


//    /* Graphical Element transposition */
//
//- (void)transpose:(nullable id)sender;
//- (void)transposeWords:(nullable id)sender;
//
//    /* Selections */
//
- (void)selectAll:(nullable id)sender
{
  moveCallback({
    .isDocument = true,
    .isSelect = true,
  });
}

- (void)selectParagraph:(nullable id)sender
{
  moveCallback({
    .isParagraph = true,
    .isSelect = true,
  });
}

- (void)selectLine:(nullable id)sender
{
  moveCallback({
    .isLine = true,
    .isSelect = true,
  });
}

- (void)selectWord:(nullable id)sender
{
  moveCallback({
    .isWord = true,
    .isSelect = true,
  });
}


//    /* Insertions and Indentations */
//
//- (void)indent:(nullable id)sender;

- (void)insertTab:(nullable id)sender
{
  moveCallback({
    .isForwards = true,
    .isTab = true,
  });
}

- (void)insertBacktab:(nullable id)sender
{
  moveCallback({
    .isBackwards = true,
    .isTab = true,
  });
}

- (void)insertNewline:(nullable id)sender
{
  moveCallback({
    .isForwards = true,
    .isEnter = true,
  });
}

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

- (void)deleteForward:(nullable id)sender
{
  moveCallback({
    .isForwards = true,
    .isDelete = true,
  });
}

- (void)deleteBackward:(nullable id)sender
{
  moveCallback({
    .isBackwards = true,
    .isDelete = true,
  });
}

- (void)deleteBackwardByDecomposingPreviousCharacter:(nullable id)sender
{
  // What's the difference to deleteForward: ?
//  moveCallback({
//    .isDelete = true,
//    .isForwards = true,
//  });
}

- (void)deleteWordForward:(nullable id)sender
{
  moveCallback({
    .isDelete = true,
    .isWord = true,
    .isForwards = true,
  });
}

- (void)deleteWordBackward:(nullable id)sender
{
  moveCallback({
    .isDelete = true,
    .isWord = true,
    .isBackwards = true,
  });
}

- (void)deleteToBeginningOfLine:(nullable id)sender
{
  moveCallback({
    .isDelete = true,
    .isLine = true,
    .isBackwards = true,
  });
}

- (void)deleteToEndOfLine:(nullable id)sender
{
  moveCallback({
    .isDelete = true,
    .isLine = true,
    .isForwards = true,
  });
}

- (void)deleteToBeginningOfParagraph:(nullable id)sender
{
  moveCallback({
    .isDelete = true,
    .isParagraph = true,
    .isBackwards = true,
  });
}

- (void)deleteToEndOfParagraph:(nullable id)sender
{
  moveCallback({
    .isDelete = true,
    .isParagraph = true,
    .isForwards = true,
  });
}

- (void)yank:(nullable id)sender
{
    NSLog(@"YANK");
}

- (void)draggingEnded:(id<NSDraggingInfo>)sender
{
    // this is called when the user drop something in the window
    
    // to initiate a drag from the window, use:
//    self performDragOperation:<#(nonnull id<NSDraggingInfo>)#>
    
//    NSLog(@"ended");
//    [[NSPasteboard generalPasteboard] pasteboardItems][0] ;
}

@end
