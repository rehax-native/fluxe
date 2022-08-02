#pragma once

#include <vector>
#include <rehaxUtils/pointers/Object.h>
#include "../../render_backend/skia/canvas.h"
#include "../render_pipeline/RenderStrategy.h"

using namespace rehaxUtils;

namespace fluxe {

class LayerTreeNode : public Object<LayerTreeNode>
{
public:
  std::vector<ObjectPointer<LayerTreeNode>> children;
  WeakObjectPointer<LayerTreeNode> parent;
  sk_sp<fluxe::Surface> surface;

  LayerTreeNode(sk_sp<fluxe::Surface> surface);

  fluxe::Canvas * getCanvas();
};


class ViewBuilder : public Object<ViewBuilder>
{
public:
  ViewBuilder();
  ObjectPointer<RenderStrategy> currentRenderStrategy;
  ObjectPointer<LayerTreeNode> rootNode = Object<LayerTreeNode>::Create(nullptr);
  ObjectPointer<LayerTreeNode> currentNode;
  float scale = 1.0;

  fluxe::Canvas * getCanvas();

  void pushLayer(int width, int height, int tag = 0);
  void popLayer(int tag = 0);

  void compose();

};

}
