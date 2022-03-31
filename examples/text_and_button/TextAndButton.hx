package examples.text_and_button;

using views.View;
using views.Button;
using views.Text;
using views.Externs;

class TextAndButton {
    public static function main() {
        var text = new Text();
        text.text = "Hello World";

        var button = new Button();
        button.title.text = "Click Me";

        var container = new View();
        container.addSubView(text);
        container.addSubView(button);

        EngineUtility.startWithView(container);
    }
}