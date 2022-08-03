#include "View.h"
#include "ViewManager.h"
#include "../layout/StackLayout.h"

using namespace fluxe;

ObjectPointer<RenderStrategy> View::defaultRenderStrategy = Object<PaintAlwaysRenderStrategy>::Create();

ObjectPointer<RenderStrategy> View::renderStrategy()
{
  return defaultRenderStrategy;
}

View::View()
{}

WeakObjectPointer<ViewManager> View::getViewManager()
{
  if (!parent.isValid()) {
    return WeakObjectPointer<ViewManager>(nullptr);
  }
  return parent->getViewManager();
}

void View::setNeedsRerender(bool needsRerender)
{
  this->needsRerender = needsRerender;
  if (needsRerender && parent.isValid()) {
    parent->setNeedsRerender(needsRerender);
  }
}

bool View::getNeedsRerender()
{
  return needsRerender;
}

std::set<ObjectPointer<View>> View::getSubViews()
{
  std::set<ObjectPointer<View>> list;
  for (auto &view : subViews) {
    list.insert(view->getThisPointer());
  }
  return list;
}

WeakObjectPointer<View> View::getParent()
{
  return parent;
}

void View::addSubView(ObjectPointer<View> view)
{
  view->removeFromParent();
  view->increaseReferenceCount();
  subViews.push_back(view.get());

  ObjectPointer<View> thisView = getThisPointer();
  WeakObjectPointer<View> thisWeak = thisView;
  view->parent = thisWeak;
  auto manager = getViewManager();
  if (manager.isValid()) {
    manager->onViewAdded(view);
  }
  view->onAddedToParent(getThisPointer());
}

void View::addSubView(ObjectPointer<View> view, ObjectPointer<View> beforeView)
{
  view->removeFromParent();
  auto beforeIt = std::find(subViews.begin(), subViews.end(), beforeView.get());
  view->increaseReferenceCount();
  subViews.insert(beforeIt, view.get());

  ObjectPointer<View> thisView = getThisPointer();
  WeakObjectPointer<View> thisWeak = thisView;
  view->parent = thisWeak;
  auto manager = getViewManager();
  if (manager.isValid()) {
    manager->onViewAdded(view);
  }
  view->onAddedToParent(getThisPointer());
}

void View::removeSubView(ObjectPointer<View> view)
{
  auto it = std::find(subViews.begin(), subViews.end(), view.get());
  if (it != subViews.end()) {
    (*it)->decreaseReferenceCount();
    subViews.erase(it);
  }

  auto manager = getViewManager();
  view->parent = ObjectPointer<View>(nullptr);
  if (manager.isValid()) {
    getViewManager()->onViewRemoved(view);
  }
  view->onRemovedFromParent(getThisPointer());
}

void View::removeFromParent()
{
  if (parent.isValid()) {
    parent->removeSubView(getThisPointer());
  }
}

void View::onAddedToParent(ObjectPointer<View> parent)
{

}

void View::onRemovedFromParent(ObjectPointer<View> parent)
{

}

void View::setLayout(ObjectPointer<ILayout> layout)
{
  this->layout = layout;
  this->needsRerender = true; // TODO this should be `needsLayout`, but that's currently not implemented yet
}

void View::setSize(LayoutSizeOverride size)
{
  this->layoutSizeOverride = size;
}

void View::setPosition(LayoutPositionOverride position)
{
  this->layoutPositionOverride = position;
}

void View::setBackgroundColor(Nullable<Color> color)
{
  this->backgroundColor = color;
  setNeedsRerender(true);
}

void View::measureLayout(LayoutConstraint constraints, PossibleLayoutSize parentSize)
{
  if (!layout.hasPointer()) {
    layout = Object<StackLayout>::Create();
  }
  // var subLayoutObjects = cast(this.subViews, Array<Dynamic>);
  // this.layoutSize = layout.layout(subLayoutObjects);
  // LayoutConstraintSetter.forwardLayoutConstraints(this);
  auto subViewsAsLayoutObjects = reinterpret_cast<std::vector<ILayoutObject *>&>(subViews);
  layoutSize = layout->layout(constraints, parentSize, this, subViewsAsLayoutObjects);
}

void View::build(ObjectPointer<ViewBuilder> builder)
{
  if (backgroundColor.isSet) {
    auto rect = Rect::MakeXYWH(0, 0, layoutSize.value.width, layoutSize.value.height);
    Paint paint;
    paint.setAntiAlias(true);
    paint.setColor(backgroundColor.value.color);
    paint.setStyle(Paint::Style::kFill_Style);
    builder->getCanvas()->drawRect(rect, paint);
  }
}
