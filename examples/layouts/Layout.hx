package examples.layouts;

using fluxe.views.View;
using fluxe.views.Button;
using fluxe.views.Text;
using fluxe.views.TextInput;
using fluxe.views.Externs;
using fluxe.views.Engine;
using fluxe.layout.StackLayout;
using fluxe.layout.FlexLayout;

class Layout {
    public static function main() {
        var layout = new Layout();
        EngineUtility.startWithView(layout.container);
    }

    public var container:View;
    private var isHorizontal = false;

    public function new() {
        container = new View();
        var layout = new StackLayout();
        layout.spacing = 10.0;
        container.layout = layout;

        var text = new Text();
        text.text = "Hello World";
        container.addSubView(text);

        var button = new Button();
        button.title.text = "Horizontal/Vertical Stack Layout";
        button.onClick = (btn:Button) -> {
            trace("Stack Clicked!");
            var layout = new StackLayout();
            layout.spacing = 10.0;
            isHorizontal = !isHorizontal;
            layout.layoutDirection = isHorizontal ? Horizontal : Vertical;
            container.layout = layout;
        };
        container.addSubView(button);

        var button = new Button();
        button.title.text = "Flex";
        button.onClick = (btn:Button) -> {
            trace("Flex Clicked!");
            var layout = new FlexLayout();
            layout.itemInfos = [
                {}, // text
                { flexGrow: 1.0 }, // button
                {}, // button
                {}, // text input
            ];
            container.layout = layout;
        };
        container.addSubView(button);

        var textInput = new TextInput();
        container.addSubView(textInput);
    }
}