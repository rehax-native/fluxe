cmake_minimum_required(VERSION 3.14)
project(fluxe)

set(CMAKE_CXX_STANDARD 20)

# include(FetchContent)
# FetchContent_Declare(
#   googletest
#   GIT_REPOSITORY https://github.com/google/googletest.git
#   GIT_TAG release-1.12.1
# )
# # For Windows: Prevent overriding the parent project's compiler/linker settings
# set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
# FetchContent_MakeAvailable(googletest)


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
)

add_library(
    fluxe-mac STATIC
    ${FLUXE_MAC_SRC_FILES}
)


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
target_link_libraries(example-text-and-button-mac fluxe-mac)
target_link_libraries(example-text-and-button-mac "-framework Foundation")
target_link_libraries(example-text-and-button-mac "-framework QuartzCore")
target_link_libraries(example-text-and-button-mac "-framework AppKit")
target_link_libraries(example-text-and-button-mac icu)
target_link_libraries(example-text-and-button-mac skia)
target_link_libraries(example-text-and-button-mac skparagraph)
target_link_libraries(example-text-and-button-mac skshaper)
target_link_libraries(example-text-and-button-mac sktext)
target_link_libraries(example-text-and-button-mac skunicode)


# enable_testing()

# add_executable(
#   ObjectPtrTest
#   fluxe/misc/Object.h
#   fluxe/misc/__test__/ReferenceCounterTest.cc
#   fluxe/misc/__test__/ReferenceCounterTreeTest.cc
#   fluxe/misc/__test__/CastTest.cc
# )
# target_link_libraries(
#   ObjectPtrTest
#   GTest::gtest_main
# )

# include(GoogleTest)
# gtest_discover_tests(ObjectPtrTest)


# To run the tests:
# cmake -S . -B build
# cmake --build build
# build/ObjectPtrTest

# cmake -G Xcode -S . -B build