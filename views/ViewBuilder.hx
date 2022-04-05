package views;

using views.Externs;
using render_pipeline.RenderStrategy;

class LayerTreeNode {
    public function new() {}

    public var children:Array<LayerTreeNode> = [];
    public var parent:LayerTreeNode = null;
    public var surface:Null<RenderSurface> = null;
    public var canvas(get, null):Canvas;

    public function get_canvas() {
        return surface.getCanvas();
    }
}

class ViewBuilder {
    public function new() {
        this.currentNode = rootNode;
    }

    public var currentRenderStrategy:RenderStrategy = View.defaultRenderStrategy;
    public var rootNode = new LayerTreeNode();
    private var currentNode:LayerTreeNode;

    public var canvas(get, null):Canvas;

    public function get_canvas() {
        return currentNode.canvas;
    }

    public function pushLayer(width:Int, height:Int, ?tag:Int):Void {
        if (currentRenderStrategy.shouldCreateNewRasterizeLayer(tag)) {
            var newNode = new LayerTreeNode();
            newNode.surface = new RenderSurface(width, height);
            newNode.parent = currentNode;
            currentNode.children.push(newNode);
            currentNode = newNode;
        }
    }

    public function popLayer(?tag:Int):Void {
        if (currentRenderStrategy.shouldCreateNewRasterizeLayer(tag)) {
            currentNode = currentNode.parent;
        }
    }

    public function compose() {
        this.canvas;
    }
}
