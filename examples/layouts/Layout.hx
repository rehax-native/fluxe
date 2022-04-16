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

        var buttonsContainer = new View();

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
        buttonsContainer.addSubView(button);

        var button = new Button();
        button.title.text = "Flex";
        button.onClick = (btn:Button) -> {
            trace("Flex Clicked!");
            isHorizontal = !isHorizontal;
            var layout = new FlexLayout();
            layout.direction = isHorizontal ? Row : Column;
            layout.itemInfos = [
                {}, // text
                { flexGrow: 1.0 }, // button
                {}, // button
                { flexGrow: 1.0 }, // text input
            ];
            container.layout = layout;
        };
        buttonsContainer.addSubView(button);

        container.addSubView(buttonsContainer);

        var textInput = new TextInput();
        container.addSubView(textInput);
    }
}