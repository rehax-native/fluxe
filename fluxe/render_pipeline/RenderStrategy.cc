#include "RenderStrategy.h"

bool fluxe::PaintAlwaysRenderStrategy::shouldCreateNewRasterizeLayer(int tag)
{
  return false;
}

bool fluxe::RasterizeAllViewsRenderStrategy::shouldCreateNewRasterizeLayer(int tag)
{
  return true;
}
