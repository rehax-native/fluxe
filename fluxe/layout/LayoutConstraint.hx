package fluxe.layout;

typedef LayoutConstraint = {
  var minWidth:Null<Float>;
  var minHeight:Null<Float>;
  var maxWidth:Null<Float>;
  var maxHeight:Null<Float>;
}

typedef LayoutOverrideResult = {
  var hasSizeHorizontally:Bool;
  var hasSizeVertically:Bool;
  var hasPositionHorizontally:Bool;
  var hasPositionVertically:Bool;
}

class LayoutConstraintSetter {
  // static public function forwardLayoutConstraints(item:fluxe.views.View) {
  //   if (item.layoutConstraints != null) {
  //     for (subView in item.subViews) {
  //       subView.layoutConstraints = {
  //           minWidth: null,
  //           minHeight: null,
  //           maxWidth: null,
  //           maxHeight: null,
  //       };

  //       if (item.layoutConstraints.minWidth != null) {
  //         subView.layoutConstraints.minWidth = item.layoutConstraints.minWidth;
  //       }
  //       if (item.layoutConstraints.minHeight != null) {
  //         subView.layoutConstraints.minHeight = item.layoutConstraints.minHeight;
  //       }
  //       if (item.layoutConstraints.maxWidth != null) {
  //         subView.layoutConstraints.maxWidth = item.layoutConstraints.maxWidth;
  //       }
  //       if (item.layoutConstraints.maxHeight != null) {
  //         subView.layoutConstraints.maxHeight = item.layoutConstraints.maxHeight;
  //       }
  //     }
  //   }
  // }

  static private function setSizeIfNeeded(item:ILayoutObject) {
    if (item.layoutSize == null) {
      item.layoutSize = {
        width: 0,
        height: 0,
      }
    }
  }

  static public function applyLayoutConstraints(item:ILayoutObject, constraints:Null<LayoutConstraint>) {
    if (constraints != null) {
      setSizeIfNeeded(item);
      if (constraints.minWidth != null && item.layoutSize.width < constraints.minWidth) {
        item.layoutSize.width = constraints.minWidth;
      }
      if (constraints.maxWidth != null && item.layoutSize.width > constraints.maxWidth) {
        item.layoutSize.width = constraints.maxWidth;
      }
      setSizeIfNeeded(item);
      if (constraints.minHeight != null && item.layoutSize.height < constraints.minHeight) {
        item.layoutSize.height = constraints.minHeight;
      }
      if (constraints.maxHeight != null && item.layoutSize.height > constraints.maxHeight) {
        item.layoutSize.height = constraints.maxHeight;
      }
    }
  }

  static public function handleLayoutOverride(constraints:Null<LayoutConstraint>, parentSize:fluxe.layout.LayoutTypes.PossibleLayoutSize, item:ILayoutObject):LayoutOverrideResult {
    var hasSizeVertically = true;
    var hasSizeHorizontally = true;
    var hasPositionHorizontally = true;
    var hasPositionVertically = true;

    if (item.layoutSizeOverride != null) {
      if (item.layoutSizeOverride.width != null) {
        switch(item.layoutSizeOverride.width) {
          case Natural:
          case Fixed(size):
            item.layoutSize.width = size;
          case Fill:
            if (parentSize.width != null) {
              item.layoutSize.width = parentSize.width;
            } else if (constraints != null) {
              if (constraints.maxWidth != null) {
                item.layoutSize.width = constraints.maxWidth;
              }
            }
            hasSizeHorizontally = false;
          case Percentage(percent):
            if (parentSize.width != null) {
              item.layoutSize.width = parentSize.width * percent / 100.0;
            } else if (constraints != null) {
              if (constraints.maxWidth != null) {
                item.layoutSize.width = constraints.maxWidth * percent / 100.0;
              }
            }
            hasSizeHorizontally = false;
        }
      }
      if (item.layoutSizeOverride.height != null) {
        switch(item.layoutSizeOverride.height) {
          case Natural:
          case Fixed(size):
            item.layoutSize.height = size;
          case Fill:
            if (parentSize.height != null) {
              item.layoutSize.height = parentSize.height;
            } else if (constraints != null) {
              if (constraints.maxHeight != null) {
                item.layoutSize.height = constraints.maxHeight;
              }
            }
            hasSizeVertically = false;
          case Percentage(percent):
            if (parentSize.height != null) {
              item.layoutSize.height = parentSize.height * percent / 100.0;
            } else if (constraints != null) {
              if (constraints.maxHeight != null) {
                item.layoutSize.height = constraints.maxHeight * percent / 100.0;
              }
            }
            hasSizeVertically = false;
        }
      }
    }

    if (item.layoutPositionOverride != null) {
      if (item.layoutPositionOverride.left != null) {
        switch(item.layoutPositionOverride.left) {
          case Natural:
          case Fixed(t):
            item.layoutPosition.left = t;
          case Percentage(percent):
            if (parentSize.width != null) {
              item.layoutPosition.left = parentSize.width * percent / 100.0;
            } else if (constraints != null) {
              if (constraints.maxWidth != null) {
                item.layoutPosition.left = constraints.maxWidth * percent / 100.0;
              }
            }
            hasPositionHorizontally = false;
        }
      }
      if (item.layoutPositionOverride.top != null) {
        switch(item.layoutPositionOverride.top) {
          case Natural:
          case Fixed(t):
            item.layoutPosition.top = t;
          case Percentage(percent):
            if (parentSize.height != null) {
              item.layoutPosition.top = parentSize.height * percent / 100.0;
            } else if (constraints != null) {
              if (constraints.maxHeight != null) {
                item.layoutPosition.top = constraints.maxHeight * percent / 100.0;
              }
            }
            hasPositionVertically = false;
        }
      }
      if (item.layoutPositionOverride.right != null) {
        switch(item.layoutPositionOverride.right) {
          case Natural:
          case Fixed(t):
            item.layoutPosition.left = t - item.layoutSize.width;
          case Percentage(percent):
            if (parentSize.width != null) {
              item.layoutPosition.left = parentSize.width * percent / 100.0 - item.layoutSize.width;
            } else if (constraints != null) {
              if (constraints.maxWidth != null) {
                item.layoutPosition.left = constraints.maxWidth * percent / 100.0 - item.layoutSize.width;
              }
            }
            hasPositionHorizontally = false;
        }
      }
      if (item.layoutPositionOverride.bottom != null) {
        switch(item.layoutPositionOverride.bottom) {
          case Natural:
          case Fixed(t):
            item.layoutPosition.top = t - item.layoutSize.height;
          case Percentage(percent):
            if (parentSize.height != null) {
              item.layoutPosition.top = parentSize.height * percent / 100.0 - item.layoutSize.height;
            } else if (constraints != null) {
              if (constraints.maxHeight != null) {
                item.layoutPosition.top = constraints.maxHeight * percent / 100.0 - item.layoutSize.height;
              }
            }
            hasPositionVertically = false;
        }
      }
    }

    return {
      hasSizeVertically: hasSizeVertically,
      hasSizeHorizontally: hasSizeHorizontally,
      hasPositionHorizontally: hasPositionHorizontally,
      hasPositionVertically: hasPositionVertically
    }
  }
}
