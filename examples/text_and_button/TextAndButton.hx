package examples.text_and_button;

using views.View;
using views.Button;
using views.Text;
using views.TextInput;
using views.Externs;

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
        container.addSubView(text);
        container.addSubView(button);
        container.addSubView(textInput);

        EngineUtility.startWithView(container);
    }
}