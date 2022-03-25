premake.modules.fetchDependencies = {}
local m = premake.modules.fetchDependencies

local p = premake

newaction {
    trigger = "fetchDependencies",
    description = "Fetch dependencies such as Skia",

    onStart = function()
        -- print("Starting Lua generation")
        skia_git = "https://skia.googlesource.com/skia"
        repo_path = "third_party/skia"

        if not os.isdir("third_party") then
          os.mkdir("third_party")
        end

        if not os.isdir(repo_path) then
          print("Cloning skia repository")
          cmd = "git clone " .. skia_git .. " " .. repo_path .. " && cd " .. repo_path .. " && git checkout 2bfcfe016daba3a72af4d43eb98f8eb10209ad70"
          print(cmd)
          os.execute(cmd)
        end
    end,

    onWorkspace = function(wks)
        -- printf("Generating Lua for workspace '%s'", wks.name)
    end,

    onProject = function(prj)
        -- printf("Generating Lua for project '%s'", prj.name)
    end,

    execute = function()
        -- print("Executing Lua action")
    end,

    onEnd = function()
        -- print("Lua generation complete")
    end
}

return m