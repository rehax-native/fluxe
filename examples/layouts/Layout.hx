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
    private var enableFlexGrow = true;
    private var flexJustify:FlexJustifyContent = FlexStart;
    private var alignItems:FlexAlignItems = FlexStart;

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
            layoutFlex();
        };
        buttonsContainer.addSubView(button);

        button = new Button();
        button.title.text = "Justify content start";
        button.onClick = (btn:Button) -> {
            flexJustify = FlexStart;
            layoutFlex();
        };
        buttonsContainer.addSubView(button);

        button = new Button();
        button.title.text = "Justify content end";
        button.onClick = (btn:Button) -> {
            flexJustify = FlexEnd;
            layoutFlex();
        };
        buttonsContainer.addSubView(button);

        button = new Button();
        button.title.text = "Toggle flex grow";
        button.onClick = (btn:Button) -> {
            enableFlexGrow = !enableFlexGrow;
            layoutFlex();
        };
        buttonsContainer.addSubView(button);

        button = new Button();
        button.title.text = "Flex align items start";
        button.onClick = (btn:Button) -> {
            alignItems = FlexStart;
            layoutFlex();
        };
        buttonsContainer.addSubView(button);

        button = new Button();
        button.title.text = "Flex align items end";
        button.onClick = (btn:Button) -> {
            alignItems = FlexEnd;
            layoutFlex();
        };
        buttonsContainer.addSubView(button);

        button = new Button();
        button.title.text = "Flex align items center";
        button.onClick = (btn:Button) -> {
            alignItems = Center;
            layoutFlex();
        };
        buttonsContainer.addSubView(button);

        container.addSubView(buttonsContainer);

        text = new Text();
        text.text = "Fixed Size";
        text.size = {
            width: Fixed(50),
            height: Fixed(50),
        }
        text.backgroundColor = Color.RGBA(1.0, 0.0, 0.0, 1.0);
        container.addSubView(text);

        var textInput = new TextInput();
        container.addSubView(textInput);

    }

    private function layoutFlex() {
        var layout = new FlexLayout();
        layout.justifyContent = flexJustify;
        layout.alignItems = alignItems;
        layout.direction = isHorizontal ? Row : Column;
        layout.itemInfos = [
            {}, // text
            { flexGrow: enableFlexGrow ? 1.0 : null }, // button container
            {}, // text
            { flexGrow: enableFlexGrow ? 2.0 : null }, // text input
        ];
        container.layout = layout;
    }
}