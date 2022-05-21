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

    private static var justifyOptions:Array<FlexJustifyContent> = [
        FlexStart,
        FlexEnd,
        Center,
        SpaceBetween,
        SpaceAround,
        SpaceEvenly,
    ];

    private static var alignOptions:Array<FlexAlignItems> = [
        FlexStart,
        FlexEnd,
        Center,
        // var Baseline; // items are aligned such as their baselines align
        Stretch,
    ];

    public var container:View;
    private var isHorizontal = false;
    private var enableFlexGrow = true;
    private var flexJustify:FlexJustifyContent = FlexStart;
    private var alignItems:FlexAlignItems = FlexStart;

    private var justifyOptionIndex = 0;
    private var alignOptionIndex = 0;

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
        button.title.text = "Justify next option";
        button.onClick = (btn:Button) -> {
            justifyOptionIndex = (justifyOptionIndex + 1) % justifyOptions.length;
            flexJustify = justifyOptions[justifyOptionIndex];
            trace('Justify content: ${flexJustify}');
            layoutFlex();
        };
        buttonsContainer.addSubView(button);

        button = new Button();
        button.title.text = "Align next option";
        button.onClick = (btn:Button) -> {
            alignOptionIndex = (alignOptionIndex + 1) % alignOptions.length;
            alignItems = alignOptions[alignOptionIndex];
            trace('Align items: ${alignItems}');
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
        textInput.backgroundColor = Color.RGBA(0.0, 1.0, 0.0, 1.0);
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