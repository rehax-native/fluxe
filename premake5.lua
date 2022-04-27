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
    systemversion "10.9"

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

  filter "system:windows"

    files {
      "examples/window/win.cc"
    }

    links { 
    }

    files {
      "shell/win/*"
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
    systemversion "10.9"
    
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

  filter "system:windows"

    architecture "x64"
    -- runtime "Debug"
    staticruntime "on"
    
    files {
      "examples/canvas/win.cc"
    }

    libdirs {
      "third_party/skia/out/Static"
    }

    links { 
      -- "gdi32",
      "opengl32",

      "skia",
      "skparagraph",
      "skshaper",
      "sktext",
      "icu",
      "skunicode",
    }

    files {
      "shell/win/*"
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
    systemversion "10.9"
    
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

  filter "system:windows"

    architecture "x64"
    -- runtime "Debug"
    staticruntime "on"
    
    files {
      "examples/render_backend/win.cc"
    }

    libdirs {
      "third_party/skia/out/Static"
    }

    links { 
      "opengl32",
      "skia",
      "skparagraph",
      "skshaper",
      "sktext",
      "icu",
      "skunicode",
    }

    files {
      "shell/win/*"
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

  filter "system:macosx"
    files {
      "engine.h",
      "engine.mm",
    }
    files {
      "shell/mac/*"
    }
    systemversion "10.9"
    
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

  filter "system:windows"
    architecture "x64"
    -- staticruntime "on"
    runtime "Debug"
    files {
      "engine.h",
      "engine.win.cc",
    }
    files {
      "shell/win/*"
    }
    
    libdirs {
      "third_party/skia/out/Static"
    }

    -- links { 
    --   "skia",
    --   "skparagraph",
    --   "skshaper",
    --   "sktext",
    --   -- "icu",
    --   "skunicode",
    -- }
    links { 
      "skia.dll",
      "skparagraph.dll",
      "skshaper.dll",
      "sktext.dll",
      "skunicode.dll",
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

  links {
    "fluxe-cpp-core",
  }

  files {
    "examples/text_and_button/**.hx",
    "examples/text_and_button/main.cpp",
  }

  libdirs {
    "third_party/skia/out/Static"
  }

  filter "system:macosx"
    systemversion "10.9"
    sysincludedirs {
      "/usr/local/lib/haxe/lib/hxcpp/4,2,1/include",
    }

    filter 'files:**.hx'
      buildcommands {
        "cd ../../examples/text_and_button && MACOSX_DEPLOYMENT_TARGET=\"10.15\" haxe textAndButton.hxml -D FLUXE_CORE_LIB=\"../../../dev/fluxe-cpp-core/bin/Debug/libfluxe-cpp-core.a\""
      }
      buildoutputs {
        "examples/text_and_button/out/liboutput.a"
      }

    linkoptions {
      "../../examples/text_and_button/out/liboutput.a",
    }
    links { 
      "Foundation.framework",
      "Cocoa.framework",
      "QuartzCore.framework",
    }
    links { 
      "skia",
      "skparagraph",
      "skshaper",
      "skunicode",
    }

  filter "system:windows"
    architecture "x64"
    -- staticruntime "on"
    runtime "Debug"
    defines {
      "HX_WINDOWS",
      "HXCPP_M64",
    }
    links { 
      "opengl32",
    }
    links { 
      "skia.dll",
      "skparagraph.dll",
      "skshaper.dll",
      "skunicode.dll",
    }
    sysincludedirs {
      "C:/tools/msys64/usr/local/haxe/haxe/lib/hxcpp/4,2,1/include",
    }
    filter 'files:**.hx'
      buildcommands {
        "cd ../../examples/text_and_button && haxe textAndButton.hxml -D HXCPP_M64 -D FLUXE_CORE_LIB=\"../../../dev/fluxe-cpp-core/bin/Debug/fluxe-cpp-core.lib\" -debug -D ABI=-MDd"
      }
      buildoutputs {
        "examples/text_and_button/out/liboutput-debug.lib"
      }
      linkoptions {
        "../../examples/text_and_button/out/liboutput-debug.lib",
      }

project "fluxe-example-layout"
  kind "WindowedApp"
  language "C++"
  cppdialect "C++20"
  location "dev/example-layout"

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
    "../../examples/layouts/out/liboutput.a",
  }

  files {
    "examples/layouts/**.hx",
    "examples/layouts/main.cpp",
  }

  filter 'files:**.hx'
    buildcommands {
      "cd ../../examples/layouts && MACOSX_DEPLOYMENT_TARGET=\"10.15\" haxe layout.hxml -D FLUXE_CORE_LIB=\"../../../dev/fluxe-cpp-core/bin/Debug/libfluxe-cpp-core.a\""
    }
    buildoutputs {
      "examples/layouts/out/liboutput.a"
    }

  filter "system:macosx"
    systemversion "10.9"
    
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