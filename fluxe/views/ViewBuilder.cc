#include "./ViewBuilder.h"
#include "View.h"

using namespace fluxe;

LayerTreeNode::LayerTreeNode(sk_sp<fluxe::Surface> surface)
:surface(surface)
{}

fluxe::Canvas * LayerTreeNode::getCanvas()
{
  return surface->getCanvas();
}

ViewBuilder::ViewBuilder()
:
currentRenderStrategy(View::defaultRenderStrategy),
currentNode(rootNode)
{}

fluxe::Canvas * ViewBuilder::getCanvas()
{
  return currentNode->getCanvas();
}

void ViewBuilder::pushLayer(int width, int height, int tag)
{
  if (currentRenderStrategy->shouldCreateNewRasterizeLayer(tag)) {
    auto surface = fluxe::Surface::MakeRasterN32Premul(width, height);
    auto canvas = surface->getCanvas();
    canvas->scale(scale, scale);

    auto newNode = Object<LayerTreeNode>::Create(surface);
    newNode->parent = currentNode;
    currentNode->children.push_back(newNode);
    currentNode = newNode;
  }
}

void ViewBuilder::popLayer(int tag)
{
  if (currentRenderStrategy->shouldCreateNewRasterizeLayer(tag)) {
    currentNode = currentNode->parent->getThisPointer();
  }
}

void ViewBuilder::compose()
{}