This project is using premake to generate project files (Xcode, Visual Studio) for local development, as well as ninja files for building releases.

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
