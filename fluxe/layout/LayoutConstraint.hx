package fluxe.layout;

typedef LayoutConstraint = {
  var explicitWidth:Null<Float>;
  var explicitHeight:Null<Float>;
  var minWidth:Null<Float>;
  var minHeight:Null<Float>;
  var maxWidth:Null<Float>;
  var maxHeight:Null<Float>;
}

class LayoutConstraintSetter {
  static public function forwardLayoutConstraints(item:fluxe.views.View) {
    if (item.layoutConstraints != null) {
      for (subView in item.subViews) {
        subView.layoutConstraints = {
            explicitWidth: null,
            explicitHeight: null,
            minWidth: null,
            minHeight: null,
            maxWidth: null,
            maxHeight: null,
        };

        if (item.layoutConstraints.minWidth != null) {
          subView.layoutConstraints.minWidth = item.layoutConstraints.minWidth;
        }
        if (item.layoutConstraints.minHeight != null) {
          subView.layoutConstraints.minHeight = item.layoutConstraints.minHeight;
        }
        if (item.layoutConstraints.maxWidth != null) {
          subView.layoutConstraints.maxWidth = item.layoutConstraints.maxWidth;
        }
        if (item.layoutConstraints.maxHeight != null) {
          subView.layoutConstraints.maxHeight = item.layoutConstraints.maxHeight;
        }
      }
    }
  }
  static public function applyLayoutConstraints(item:ILayoutObject) {
    if (item.layoutConstraints != null) {
      if (item.layoutConstraints.explicitWidth != null) {
        item.layoutSize.width = item.layoutConstraints.explicitWidth;
      } else {
        if (item.layoutConstraints.minWidth != null && item.layoutSize.width < item.layoutConstraints.minWidth) {
          item.layoutSize.width = item.layoutConstraints.minWidth;
        }
        if (item.layoutConstraints.maxWidth != null && item.layoutSize.width > item.layoutConstraints.maxWidth) {
          item.layoutSize.width = item.layoutConstraints.maxWidth;
        }
      }
      if (item.layoutConstraints.explicitHeight != null) {
        item.layoutSize.height = item.layoutConstraints.explicitHeight;
      } else {
        if (item.layoutConstraints.minHeight != null && item.layoutSize.height < item.layoutConstraints.minHeight) {
          item.layoutSize.height = item.layoutConstraints.minHeight;
        }
        if (item.layoutConstraints.maxHeight != null && item.layoutSize.height > item.layoutConstraints.maxHeight) {
          item.layoutSize.height = item.layoutConstraints.maxHeight;
        }
      }
    }
  }
}
