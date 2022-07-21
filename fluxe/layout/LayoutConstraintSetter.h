#pragma once

#include "../misc/Nullable.h"
#include "ILayoutObject.h"

namespace fluxe {

class LayoutConstraintSetter
{
private:
  // static public function forwardLayoutConstraints(item:fluxe.views.View) {
  //   if (item->layoutConstraints != null) {
  //     for (subView in item->subViews) {
  //       subView.layoutConstraints = {
  //           minWidth: null,
  //           minHeight: null,
  //           maxWidth: null,
  //           maxHeight: null,
  //       };

  //       if (item->layoutConstraints.minWidth != null) {
  //         subView.layoutConstraints.minWidth = item->layoutConstraints.minWidth;
  //       }
  //       if (item->layoutConstraints.minHeight != null) {
  //         subView.layoutConstraints.minHeight = item->layoutConstraints.minHeight;
  //       }
  //       if (item->layoutConstraints.maxWidth != null) {
  //         subView.layoutConstraints.maxWidth = item->layoutConstraints.maxWidth;
  //       }
  //       if (item->layoutConstraints.maxHeight != null) {
  //         subView.layoutConstraints.maxHeight = item->layoutConstraints.maxHeight;
  //       }
  //     }
  //   }
  // }

  static void setSizeIfNeeded(ILayoutObject * item);

public:

  static void applyLayoutConstraints(ILayoutObject * item, Nullable<LayoutConstraint> constraints);
  static LayoutOverrideResult handleLayoutOverride(Nullable<LayoutConstraint> constraints, PossibleLayoutSize parentSize, ILayoutObject * item);
};

}
