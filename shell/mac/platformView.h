#pragma once

#import <Cocoa/Cocoa.h>

// #define FLUXE_USE_OPENGL 0
#define FLUXE_USE_METALKIT 1

#ifdef FLUXE_USE_METALKIT
#import <MetalKit/MetalKit.h>
#include "include/gpu/GrBackendSurface.h"
#include "include/gpu/GrDirectContext.h"
#include "include/gpu/mtl/GrMtlTypes.h"
#define VIEW_BASE MTKView
#else
#define VIEW_BASE NSView
#endif

@interface FluxePlatformView : VIEW_BASE
{
}

- (id) init;

- (void) drawRect: (NSRect) bounds;
- (CGContextRef) getCGContextRef;

#ifdef FLUXE_USE_METALKIT
@property (strong, nonatomic) id<MTLDevice> metalDevice;
@property (assign, nonatomic) id<MTLCommandQueue> metalQueue;
@property (assign, nonatomic) GrDirectContext* grContext;
#endif

@end
