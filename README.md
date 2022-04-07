# fluxe

Fluxe is a library that lets you write cross platform user interfaces using the Haxe programming language and Skia as the rendering backend.

It shares commonalities with flutter, but has the advantage that there is no need for a dart runtime, since Haxe transpiles to the target's native language (C++/Java/JavaScript).
This eliminates the need to bridge between different languages, avoids marshalling, and reduces bundle size.

fluxe is in an early stage of development.

## Example

```haxe
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
```


## Building

This project is using premake to generate project files (Xcode, Visual Studio) for local development, as well as makefiles for building releases.

To get your build environment set up, you first need to get premake and haxe for your machine, and then run this command:

```
python prepare.py
```
This will give you a project file in the `dev` directory that you can use to run different examples.


The following command will build Skia and the fluxe static library. You need these to run the examples and to create a release.

```
python build.py
```

Finally, to publish the static library and header files to github, run:

```
python publish.py
```
