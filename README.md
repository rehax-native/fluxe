This project is using premake to generate project files (Xcode, Visual Studio) for local development, as well as ninja files for building releases.

To get your build environment set up, you first need to get premake and haxe for your machine, and then run these commands:

1. Download dependencies such as Skia

```
premake5 fetchDependencies
```

2. Generate the project file

```
premake5 generateProject xcode
premake5 generateProject vs2022
```

You now have a project file in the [TBD] directory that you can use to run different examples.

In order to build a release, you run `premake5 fetchDependencies` and `premake5 ninja` to create the ninja files. Then you can run `ninja -C [TBD]` to build the release.
