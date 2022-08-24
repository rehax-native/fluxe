#pragma once

#include <rehaxUtils/pointers/Object.h>
#include "../events/IEventListener.h"
#include "../layout/ILayout.h"
#include "../render_pipeline/RenderStrategy.h"
#include "ViewBuilder.h"
#include "Color.h"

namespace fluxe {

class ViewManager;

struct BorderRadius
{
  float topLeft = 0;
  float topRight = 0;
  float bottomLeft = 0;
  float bottomRight = 0;
};

class View : virtual public Object<View>, public ILayoutObject, public IEventListenerContainer
{
public:
  static ObjectPointer<RenderStrategy> defaultRenderStrategy;

  View();
  virtual ObjectPointer<RenderStrategy> renderStrategy();

  virtual WeakObjectPointer<ViewManager> getViewManager();
  virtual void setNeedsRerender(bool needsRerender);
  bool getNeedsRerender();
  std::vector<ObjectPointer<View>> getSubViews();
  WeakObjectPointer<View> getParent();
  virtual void addSubView(ObjectPointer<View> view);
  virtual void addSubView(ObjectPointer<View> view, ObjectPointer<View> beforeView);
  void removeSubView(ObjectPointer<View> view);
  void removeFromParent();
  bool isInSubViewTreeOf(ObjectPointer<View> view);

  virtual void onAddedToParent(ObjectPointer<View> parent);
  virtual void onRemovedFromParent(ObjectPointer<View> parent);
  void setLayout(ObjectPointer<ILayout> layout);

  void setSize(LayoutSizeOverride size);
  void setPosition(LayoutPositionOverride position);
  void setBackgroundColor(Nullable<Color> color);

  virtual void measureLayout(LayoutConstraint constraints, PossibleLayoutSize parentSize);
  virtual void buildEnter(ObjectPointer<ViewBuilder> builder);
  virtual void build(ObjectPointer<ViewBuilder> builder);
  virtual void buildExit(ObjectPointer<ViewBuilder> builder);

  void setBorderRadius(Nullable<BorderRadius> borderRadius);
  void setBorderWidth(float width);
  void setBorderColor(Nullable<Color> color);

  ObjectPointer<ILayout> layout;

protected:
  Nullable<Color> backgroundColor;
private:
  bool needsRerender = false;
  Nullable<BorderRadius> borderRadius;
  float borderWidth = 0;
  Nullable<Color> borderColor;

  std::vector<View *> subViews;
  WeakObjectPointer<View> parent;

};

}
