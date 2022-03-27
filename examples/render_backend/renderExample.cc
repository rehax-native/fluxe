#include "render_backend/skia/canvas.h"
#include "render_backend/skia/paint.h"

#include "third_party/skia/include/core/SkData.h"
#include "third_party/skia/include/core/SkImage.h"
#include "third_party/skia/include/core/SkBitmap.h"
#include "third_party/skia/include/core/SkSurface.h"

using namespace fluxe;

sk_sp<SkSurface> raster(int width, int height, void (*draw)(SkCanvas*), const char* path) {
  sk_sp<SkSurface> rasterSurface = SkSurface::MakeRasterN32Premul(width, height);
  SkCanvas* rasterCanvas = rasterSurface->getCanvas();
  draw(rasterCanvas);
  return rasterSurface;
}

void draw(Canvas *canvas)
{
  canvas->drawColor(SK_ColorWHITE);
  
  Paint paint;
  paint.setStyle(Paint::kFill_Style);
  paint.setAntiAlias(true);
  paint.setStrokeWidth(4);
  paint.setColor(0xff4285F4);
  
  fluxe::Rect rect = fluxe::Rect::MakeXYWH(10, 10, 100, 160);
  canvas->drawRect(rect, paint);
  
  fluxe::RRect oval;
  oval.setOval(rect);
  oval.offset(40, 80);
  paint.setColor(0xffDB4437);
  canvas->drawRRect(oval, paint);
  
  paint.setColor(0xff0F9D58);
  canvas->drawCircle(180, 50, 25, paint);
  
  rect.offset(80, 50);
  paint.setColor(0xffF4B400);
  paint.setStyle(Paint::kStroke_Style);
  canvas->drawRoundRect(rect, 10, 10, paint);
}

SkBitmap drawExample(int width, int height)
{
  sk_sp<SkSurface> mSurface = raster(width, height, draw, nullptr);
  
  SkPixmap pixmap;
  mSurface->peekPixels(&pixmap);
  SkBitmap bmp;
  bmp.installPixels(pixmap);

  return bmp;
}
