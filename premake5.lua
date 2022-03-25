require "fetchDependencies"

workspace "fluxe"
  configurations { "Debug", "Release" }

project "fluxe-example-canvas"
  kind "WindowedApp"
  language "C++"
  location "dev/example-canvas"
  files {
    "examples/canvas/*"
  }
