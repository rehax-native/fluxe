#pragma once

#import <Cocoa/Cocoa.h>

#ifdef FLUXE_USE_OPENGL
#define VIEW_BASE NSOpenGLView
#else
#define VIEW_BASE NSView
#endif

@interface FluxePlatformView : VIEW_BASE
{
}

- (id) init;

- (void) drawRect: (NSRect) bounds;
- (void) render;

@end
