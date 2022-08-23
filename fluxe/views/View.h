#pragma once

#include <rehaxUtils/pointers/Object.h>
#include "../events/IEventListener.h"
#include "../layout/ILayout.h"
#include "../render_pipeline/RenderStrategy.h"
#include "ViewBuilder.h"
#include "Color.h"

namespace fluxe {

class ViewManager;

class View : virtual public Object<View>, public ILayoutObject, public IEventListenerContainer
{
public:
  static ObjectPointer<RenderStrategy> defaultRenderStrategy;

  View();
  virtual ObjectPointer<RenderStrategy> renderStrategy();

  virtual WeakObjectPointer<ViewManager> getViewManager();
  virtual void setNeedsRerender(bool needsRerender);
  bool getNeedsRerender();
  std::set<ObjectPointer<View>> getSubViews();
  WeakObjectPointer<View> getParent();
  virtual void addSubView(ObjectPointer<View> view);
  virtual void addSubView(ObjectPointer<View> view, ObjectPointer<View> beforeView);
  void removeSubView(ObjectPointer<View> view);
  void removeFromParent();

  virtual void onAddedToParent(ObjectPointer<View> parent);
  virtual void onRemovedFromParent(ObjectPointer<View> parent);
  void setLayout(ObjectPointer<ILayout> layout);

  void setSize(LayoutSizeOverride size);
  void setPosition(LayoutPositionOverride position);
  void setBackgroundColor(Nullable<Color> color);

  virtual void measureLayout(LayoutConstraint constraints, PossibleLayoutSize parentSize);
  virtual void build(ObjectPointer<ViewBuilder> builder);

  ObjectPointer<ILayout> layout;

protected:
  Nullable<Color> backgroundColor;
private:
  bool needsRerender = false;
  std::vector<View *> subViews;
  WeakObjectPointer<View> parent;

};

}
