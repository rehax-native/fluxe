#pragma once

#include <rehaxUtils/pointers/Object.h>

using namespace rehaxUtils;

namespace fluxe {

class RenderStrategy : public Object<RenderStrategy>
{
public:
  virtual bool shouldCreateNewRasterizeLayer(int tag = 0) = 0;
};

class PaintAlwaysRenderStrategy : public RenderStrategy
{
public:
  virtual bool shouldCreateNewRasterizeLayer(int tag = 0);
};

class RasterizeAllViewsRenderStrategy : public RenderStrategy
{
  virtual bool shouldCreateNewRasterizeLayer(int tag = 0);
};

}
