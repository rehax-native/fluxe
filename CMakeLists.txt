cmake_minimum_required(VERSION 3.14)
project(fluxe)

set(CMAKE_CXX_STANDARD 20)

include(FetchContent)
FetchContent_Declare(
  googletest
  GIT_REPOSITORY https://github.com/google/googletest.git
  GIT_TAG release-1.12.1
)
# For Windows: Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

FetchContent_Declare(rehaxUtils
    GIT_REPOSITORY https://github.com/rehax-native/utils.git
    GIT_TAG        main
)
FetchContent_MakeAvailable(rehaxUtils)

include_directories(${rehaxUtils_SOURCE_DIR})


include_directories(.)
include_directories(third_party/skia)

file(GLOB FLUXE_MAC_SRC_FILES
    fluxe/events/*.cc
    fluxe/layout/*.cc
    fluxe/render_pipeline/*.cc
    fluxe/views/*.cc
    shell/mac/*.mm
    engine.mm
    fluxe/events/*.h
    fluxe/layout/*.h
    fluxe/render_pipeline/*.h
    fluxe/views/*.h
    fluxe/misc/*.h
    shell/mac/*.h
    shell/*.h
    engine.h
    render_backend/skia/*.h

    third_party/skia/tools/skottie_ios_app/SkMetalViewBridge.mm
    third_party/skia/tools/skottie_ios_app/GrContextHolder.mm
)

add_library(
    fluxe-mac STATIC
    ${FLUXE_MAC_SRC_FILES}
)
target_compile_definitions(fluxe-mac PUBLIC -DSK_METAL)


link_directories(./dist)
add_executable(
    example-text-and-button-mac MACOSX_BUNDLE
    examples/text_and_button/main.cpp
)
set_target_properties(
    example-text-and-button-mac PROPERTIES
    BUNDLE True
    MACOSX_BUNDLE_GUI_IDENTIFIER dev.rehax.fluxe.example-text-and-button
    MACOSX_BUNDLE_BUNDLE_NAME example-text-and-button-mac
    MACOSX_BUNDLE_BUNDLE_VERSION "0.1"
    MACOSX_BUNDLE_SHORT_VERSION_STRING "0.1"
    MACOSX_BUNDLE_INFO_PLIST examples/text_and_button/info.plist
)
target_link_libraries(
  example-text-and-button-mac
  fluxe-mac
  "-framework Foundation"
  "-framework QuartzCore"
  "-framework AppKit"
  "-framework Metal"
  "-framework MetalKit"
  icu
  skia
  skparagraph
  skshaper
  sktext
  skunicode
  skottie
  sksg
)

add_executable(
    example-layouts-mac MACOSX_BUNDLE
    examples/layouts/main.cpp
)
set_target_properties(
    example-layouts-mac PROPERTIES
    BUNDLE True
    MACOSX_BUNDLE_GUI_IDENTIFIER dev.rehax.fluxe.example-layouts
    MACOSX_BUNDLE_BUNDLE_NAME example-layouts-mac
    MACOSX_BUNDLE_BUNDLE_VERSION "0.1"
    MACOSX_BUNDLE_SHORT_VERSION_STRING "0.1"
    MACOSX_BUNDLE_INFO_PLIST examples/layouts/info.plist
)
target_link_libraries(
  example-layouts-mac
  fluxe-mac
  "-framework Foundation"
  "-framework QuartzCore"
  "-framework AppKit"
  "-framework Metal"
  "-framework MetalKit"
  icu
  skia
  skparagraph
  skshaper
  sktext
  skunicode
  skottie
  sksg
)


enable_testing()

# To run the tests:
# cmake -S . -B build_test
# cmake --build build_test --target ObjectPtrTest
# build_test/ObjectPtrTest

# To create an xcode project for development:
# cmake -G Xcode -S . -B build