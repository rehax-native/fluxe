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
