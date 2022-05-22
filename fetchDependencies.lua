premake.modules.fetchDependencies = {}
local m = premake.modules.fetchDependencies

local p = premake

newaction {
    trigger = "fetchDependencies",
    description = "Fetch dependencies such as Skia",

    onStart = function()
        if not os.isdir("third_party") then
          os.mkdir("third_party")
        end

        skia_git = "https://skia.googlesource.com/skia"
        repo_path = "third_party/skia"

        if not os.isdir(repo_path) then
          print("Cloning skia repository")
          cmd = "git clone " .. skia_git .. " " .. repo_path .. " && cd " .. repo_path .. " && git checkout 2bfcfe016daba3a72af4d43eb98f8eb10209ad70"
          print(cmd)
          os.execute(cmd)
        end

        path_sep = package.config:sub(1, 1)
        is_win = path_sep == "\\"
        if is_win then
          depot_tools_url = "https://storage.googleapis.com/chrome-infra/depot_tools.zip"
          repo_path = "third_party/depot_tools"
          http.download(depot_tools_url, repo_path .. ".zip")
          zip.extract(repo_path .. ".zip", repo_path)
        else
          depot_tools_git = "https://chromium.googlesource.com/chromium/tools/depot_tools.git"
          repo_path = "third_party/depot_tools"

          if not os.isdir(repo_path) then
            print("Cloning depot_tools repository")
            cmd = "git clone " .. depot_tools_git .. " " .. repo_path
            print(cmd)
            os.execute(cmd)
          end
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