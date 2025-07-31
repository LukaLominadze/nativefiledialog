-- Native file dialog premake5 script
--
-- This can be ran directly, but commonly, it is only run
-- by package maintainers.
--
-- IMPORTANT NOTE: premake5 alpha 9 does not handle this script
-- properly.  Build premake5 from Github master, or, presumably,
-- use alpha 10 in the future.


newoption {
   trigger     = "linux_backend",
   value       = "B",
   description = "Choose a dialog backend for linux",
   allowed = {
      { "gtk3", "GTK 3 - link to gtk3 directly" },      
      { "zenity", "Zenity - generate dialogs on the end users machine with zenity" }
   }
}

if not _OPTIONS["linux_backend"] then
   _OPTIONS["linux_backend"] = "gtk3"
end

workspace "NativeFileDialog"
  -- these dir specifications assume the generated files have been moved
  -- into a subdirectory.  ex: $root/build/makefile
  local root_dir = path.join(path.getdirectory(_SCRIPT),"../")
  local build_dir = path.join(root_dir,"build/")
  configurations { "Release", "Debug" }

  -- Apple stopped distributing an x86 toolchain.  Xcode 11 now fails to build with an 
  -- error if the invalid architecture is present.
  --
  -- Add it back in here to build for legacy systems.
  filter "system:macosx"
    platforms {"x64"}
  filter "system:windows or system:linux"
    platforms {"x64", "x86"}
  

  objdir(path.join(build_dir, "obj/"))

  -- architecture filters
  filter "configurations:x86"
    architecture "x86"
  
  filter "configurations:x64"
    architecture "x64"

  -- debug/release filters
  filter "configurations:Debug"
    defines {"DEBUG"}
    symbols "On"
    targetsuffix "_d"

  filter "configurations:Release"
    defines {"NDEBUG"}
    optimize "On"
  
  filter "configurations:Distribution"
    defines {"NDEBUG"}
    optimize "On"

include "build/premake5.lua"