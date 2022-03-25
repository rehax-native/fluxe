#include "third_party/skia/include/core/SkData.h"
#include "third_party/skia/include/core/SkImage.h"
#include "third_party/skia/include/core/SkBitmap.h"
#include "third_party/skia/include/core/SkStream.h"
#include "third_party/skia/include/core/SkSurface.h"
#include "third_party/skia/include/core/SkCanvas.h"
#include "third_party/skia/include/core/SkRRect.h"

sk_sp<SkSurface> raster(int width, int height, void (*draw)(SkCanvas*), const char* path) {
  sk_sp<SkSurface> rasterSurface = SkSurface::MakeRasterN32Premul(width, height);
  SkCanvas* rasterCanvas = rasterSurface->getCanvas();
  draw(rasterCanvas);
  
  return rasterSurface;
  //    sk_sp<SkImage> img(rasterSurface->makeImageSnapshot());
  //    if (!img) { return; }
  //    sk_sp<SkData> png(img->encode());
  //    if (!png) { return; }
  //    SkFILEWStream out(path);
  //    (void)out.write(png->data(), png->size());
}

void draw(SkCanvas *canvas)
{
  canvas->drawColor(SK_ColorWHITE);
  
  SkPaint paint;
  paint.setStyle(SkPaint::kFill_Style);
  paint.setAntiAlias(true);
  paint.setStrokeWidth(4);
  paint.setColor(0xff4285F4);
  
  SkRect rect = SkRect::MakeXYWH(10, 10, 100, 160);
  canvas->drawRect(rect, paint);
  
  SkRRect oval;
  oval.setOval(rect);
  oval.offset(40, 80);
  paint.setColor(0xffDB4437);
  canvas->drawRRect(oval, paint);
  
  paint.setColor(0xff0F9D58);
  canvas->drawCircle(180, 50, 25, paint);
  
  rect.offset(80, 50);
  paint.setColor(0xffF4B400);
  paint.setStyle(SkPaint::kStroke_Style);
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
