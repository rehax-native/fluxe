require "fetchDependencies"

workspace "fluxe"
  configurations { "Debug", "Release" }
  location "dev"

project "fluxe-example-window"
  kind "WindowedApp"
  language "C++"
  cppdialect "C++20"
  location "dev/examples-window"

  includedirs {
    "."
  }

  filter "system:macosx"
    systemversion "10.15"

    files {
      "examples/window/mac.mm"
    }

    links { 
      "Cocoa.framework",
      "QuartzCore.framework",
    }

    files {
      "shell/mac/*"
    }


project "fluxe-example-canvas"
  kind "WindowedApp"
  language "C++"
  cppdialect "C++20"
  location "dev/example-canvas"

  includedirs {
    ".",
    "./third_party/skia",
  }

  filter "system:macosx"
    systemversion "10.15"
    
    files {
      "examples/canvas/mac.mm"
    }

    libdirs {
      "third_party/skia/out/Static"
    }

    links { 
      "Cocoa.framework",
      "QuartzCore.framework",
      "skia",
    }

    files {
      "shell/mac/*"
    }

project "fluxe-example-render-backend"
  kind "WindowedApp"
  language "C++"
  cppdialect "C++20"
  location "dev/example-render-backend"

  includedirs {
    ".",
    "./third_party/skia",
  }

  filter "system:macosx"
    systemversion "10.15"
    
    files {
      "examples/render_backend/mac.mm"
    }

    libdirs {
      "third_party/skia/out/Static"
    }

    links { 
      "Cocoa.framework",
      "QuartzCore.framework",
      "skia",
    }

    files {
      "shell/mac/*"
    }

project "fluxe-cpp-core"
  kind "StaticLib"
  language "C++"
  cppdialect "C++20"
  location "dev/fluxe-cpp-core"

  includedirs {
    ".",
    "./third_party/skia",
  }

  files {
    "engine.h",
    "engine.mm",
    "shell/timer.h",
    "shell/timer.mm",
  }

  filter "system:macosx"
    files {
      "shell/mac/*"
    }
    systemversion "10.15"
    
    libdirs {
      "third_party/skia/out/Static"
    }

    links { 
      "Foundation.framework",
      "Cocoa.framework",
      "QuartzCore.framework",
      "skia",
      "skparagraph",
    }

project "fluxe-example-text-and-button"
  kind "WindowedApp"
  language "C++"
  cppdialect "C++20"
  location "dev/example-text-and-button"

  includedirs {
    ".",
    "./third_party/skia",
  }

  sysincludedirs {
    "/usr/local/lib/haxe/lib/hxcpp/4,2,1/include",
  }

  links {
    "fluxe-cpp-core",
  }
  linkoptions {
    "../../examples/text_and_button/out/liboutput.a",
  }

  files {
    "examples/text_and_button/**.hx",
    "examples/text_and_button/main.cpp",
  }

  filter 'files:**.hx'
    buildcommands {
      "cd ../../examples/text_and_button && MACOSX_DEPLOYMENT_TARGET=\"10.15\" haxe textAndButton.hxml -D FLUXE_CORE_LIB=\"../../../dev/fluxe-cpp-core/bin/Debug/libfluxe-cpp-core.a\""
    }
    buildoutputs {
      "examples/text_and_button/out/liboutput.a"
    }

  filter "system:macosx"
    systemversion "10.15"
    
    libdirs {
      "third_party/skia/out/Static"
    }

    links { 
      "Foundation.framework",
      "Cocoa.framework",
      "QuartzCore.framework",
      "skia",
      "skparagraph",
      "skshaper",
      "skunicode",
    }