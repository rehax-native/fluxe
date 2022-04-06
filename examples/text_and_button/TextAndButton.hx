package examples.text_and_button;

using fluxe.views.View;
using fluxe.views.Button;
using fluxe.views.Text;
using fluxe.views.TextInput;
using fluxe.views.Externs;
using fluxe.views.Engine;
using fluxe.layout.StackLayout;

class TextAndButton {
    public static function main() {
        var text = new Text();
        text.text = "Hello World";

        var button = new Button();
        button.title.text = "Click Me";
        button.onClick = (btn:Button) -> {
            trace("Clicked!");
        };

        var textInput = new TextInput();

        var container = new View();
        var layout = new StackLayout();
        layout.spacing = 10.0;
        container.layout = layout;
        container.addSubView(text);
        container.addSubView(button);
        container.addSubView(textInput);

        EngineUtility.startWithView(container);
    }
}