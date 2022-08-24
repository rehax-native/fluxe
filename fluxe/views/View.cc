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

std::vector<ObjectPointer<View>> View::getSubViews()
{
  std::vector<ObjectPointer<View>> list;
  for (auto &view : subViews) {
    list.push_back(view->getThisPointer());
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
  bool didFind = it != subViews.end();
  if (didFind) {
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

bool View::isInSubViewTreeOf(ObjectPointer<View> view)
{
  auto parent = getParent();
  while (parent.isValid()) {
    if (view == parent) {
      return true;
    }
    parent = parent->getParent();
  }
  return false;
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

void View::setBorderRadius(Nullable<BorderRadius> borderRadius)
{
  this->borderRadius = borderRadius;
}

void View::setBorderWidth(float width)
{
  borderWidth = width;
}

void View::setBorderColor(Nullable<Color> color)
{
  borderColor = color;
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

void View::buildEnter(ObjectPointer<ViewBuilder> builder)
{
  builder->getCanvas()->save();
}

void View::buildExit(ObjectPointer<ViewBuilder> builder)
{
  builder->getCanvas()->restore();
}

void View::build(ObjectPointer<ViewBuilder> builder)
{
  SkRRect roundedRect;
  bool hasRounded = false;

  if (borderRadius.isSet) {
    SkVector radii[4];
    radii[SkRRect::Corner::kUpperLeft_Corner] = SkVector::Make(borderRadius.value.topLeft, borderRadius.value.topLeft);
    radii[SkRRect::Corner::kUpperRight_Corner] = SkVector::Make(borderRadius.value.topRight, borderRadius.value.topRight);
    radii[SkRRect::Corner::kLowerRight_Corner] = SkVector::Make(borderRadius.value.bottomRight, borderRadius.value.bottomRight);
    radii[SkRRect::Corner::kLowerLeft_Corner] = SkVector::Make(borderRadius.value.bottomLeft, borderRadius.value.bottomLeft);
    roundedRect.setRectRadii(Rect::MakeXYWH(0, 0, layoutSize.value.width, layoutSize.value.height), radii);
    builder->getCanvas()->clipRRect(roundedRect);
    hasRounded = true;
  }

  if (backgroundColor.isSet) {
    auto rect = Rect::MakeXYWH(0, 0, layoutSize.value.width, layoutSize.value.height);
    Paint paint;
    paint.setAntiAlias(true);
    paint.setColor(backgroundColor.value.color);
    paint.setStyle(Paint::Style::kFill_Style);
    builder->getCanvas()->drawRect(rect, paint);
  }


  if (borderColor.isSet && borderWidth > 0) {
    Paint paint;
    paint.setAntiAlias(true);
    paint.setColor(borderColor.value.color);
    paint.setStyle(Paint::Style::kStroke_Style);
    paint.setStrokeWidth(borderWidth);
    if (hasRounded) {
      RRect r = roundedRect;
      r.inset(1, 1);
      builder->getCanvas()->drawRRect(r, paint);
    } else {
      auto rect = Rect::MakeXYWH(0, 0, layoutSize.value.width, layoutSize.value.height);
      builder->getCanvas()->drawRect(rect, paint);
    }
  }
}
