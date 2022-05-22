require "fetchDependencies"

workspace "fluxe"
  configurations { "Debug", "Release" }
  location "dev"

  xcodebuildsettings {
     ENABLE_TESTABILITY = "YES",

     CLANG_WARN_INFINITE_RECURSION = "YES",
     CLANG_WARN_UNREACHABLE_CODE = "YES",
     GCC_WARN_UNUSED_FUNCTION = "YES",
     GCC_WARN_UNINITIALIZED_AUTOS = "YES",
     CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = "YES",
     CLANG_WARN__DUPLICATE_METHOD_MATCH = "YES",
     CLANG_WARN_EMPTY_BODY = "YES",
     ENABLE_STRICT_OBJC_MSGSEND = "YES",
     CLANG_WARN_BOOL_CONVERSION = "YES",
     CLANG_WARN_CONSTANT_CONVERSION = "YES",
     GCC_WARN_64_TO_32_BIT_CONVERSION = "YES",
     CLANG_WARN_ENUM_CONVERSION = "YES",
     CLANG_WARN_INT_CONVERSION = "YES",
     CLANG_WARN_NON_LITERAL_NULL_CONVERSION = "YES",
     CLANG_WARN_OBJC_LITERAL_CONVERSION = "YES",
     GCC_NO_COMMON_BLOCKS = "YES",
     CLANG_WARN_RANGE_LOOP_ANALYSIS = "YES",
     CLANG_WARN_STRICT_PROTOTYPES = "YES",
     CLANG_WARN_COMMA = "YES",
     CLANG_WARN_SUSPICIOUS_MOVE = "YES",
     GCC_WARN_UNDECLARED_SELECTOR = "YES",
     CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = "YES",

    CLANG_ENABLE_OBJC_WEAK = "YES",
    CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = "YES",
    CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = "YES",
    MACOSX_DEPLOYMENT_TARGET="10.9",

    CLANG_CXX_LIBRARY = "libc++",
    CODE_SIGN_IDENTITY = "-",
    ARCHS = "$(ARCHS_STANDARD)",
  }

  filter "configurations:Debug"
    xcodebuildsettings {
      ONLY_ACTIVE_ARCH = "YES",
    }

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
    staticruntime "off"
    runtime "Release"
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
      "skia.lib",
      -- "skia.dll.lib",
      -- "skparagraph.dll.lib",
      -- "skshaper.dll.lib",
      -- "sktext.dll.lib",
      -- "skunicode.dll.lib",
      -- "icu.lib",
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

  libdirs {
    "third_party/skia/out/Static"
  }


  files {
    "examples/text_and_button/**.hx",
    "examples/text_and_button/main.cpp",
  }

  links { 
    "fluxe-cpp-core",
  }

  filter "system:macosx"
    systemversion "10.9"
    
    sysincludedirs {
      "/usr/local/lib/haxe/lib/hxcpp/4,2,1/include",
    }

    linkoptions {
      "../../examples/text_and_button/out/liboutput.a",
    }

    prebuildcommands {
      "cd ../../examples/text_and_button && MACOSX_DEPLOYMENT_TARGET=\"10.9\" haxe textAndButton.hxml -D FLUXE_CORE_LIB=\"../../../dev/fluxe-cpp-core/bin/Debug/libfluxe-cpp-core.a\""
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

  filter "system:windows"
    architecture "x64"
    staticruntime "off"
    runtime "Release"
    defines {
      "HX_WINDOWS",
      "HXCPP_M64",
    }
    links { 
      "opengl32",
    }
    links { 
      "skia.lib",
      "skparagraph.lib",
      "skshaper.lib",
      "skunicode.lib",
      "sktext.lib",
      "icu.lib",
      -- "skia.dll.lib",
      -- "skparagraph.dll.lib",
      -- "skshaper.dll.lib",
      -- "skunicode.dll.lib",
      -- "sktext.dll.lib",
      -- "icu.lib",
    }
    linkoptions {
      "../../examples/text_and_button/out/liboutput.lib",
    }
    sysincludedirs {
      "C:/tools/msys64/usr/local/haxe/haxe/lib/hxcpp/4,2,1/include",
    }
    prebuildcommands {
      "cd ../../examples/text_and_button && haxe textAndButton.hxml -D HXCPP_M64 -D FLUXE_CORE_LIB=\"../../../dev/fluxe-cpp-core/bin/Release/fluxe-cpp-core.lib\" -D ABI=-MD"
    }
    postbuildcommands {
      "copy ..\\..\\build\\icudtl.dat ..\\..\\dev\\example-text-and-button\\bin\\Release\\icudtl.dat"
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

  prebuildcommands {
    "cd ../../examples/layouts && MACOSX_DEPLOYMENT_TARGET=\"10.9\" haxe layout.hxml -D FLUXE_CORE_LIB=\"../../../dev/fluxe-cpp-core/bin/Debug/libfluxe-cpp-core.a\""
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

project "fluxe-example-paths"
  kind "WindowedApp"
  language "C++"
  cppdialect "C++20"
  location "dev/example-paths"

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
    "../../examples/paths/out/liboutput.a",
  }

  files {
    "examples/paths/**.hx",
    "examples/paths/main.cpp",
  }

  prebuildcommands {
    "cd ../../examples/paths && MACOSX_DEPLOYMENT_TARGET=\"10.9\" haxe layout.hxml -D FLUXE_CORE_LIB=\"../../../dev/fluxe-cpp-core/bin/Debug/libfluxe-cpp-core.a\""
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