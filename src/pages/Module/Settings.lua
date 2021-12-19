--- Load modules by their name with either `require()` or `mw.loadData()`.
---
--- "other" should only exist if it's not for data (i.e. requiring an Infobox)
--- @param name string The path to the module.
--- @param other boolean Should it be loaded with `require()` or `mw.loadData()`, true for `require()`.
--- @return any
local function LoadModule(name, other)
    return function()
        local Module
        pcall(function() Module = other and require(name) or mw.loadData(name) end)
        return Module
    end
end

---@class SettingsModule
local Settings = {}

-- Get Data things for large values (function)

-- Utils
---@type function<GenerateRobloxItemUrlModule>
Settings.GetGenerateRobloxItemUrl = LoadModule("Module:Utils/GenerateRobloxItemUrl", true)

-- Data values (string | number | boolean | table)
Settings.RobloxUrl = "https://www.roblox.com"
Settings.RobloxItemTypeToItemTypeInUrl = {
    Bundle = "bundles",
    DevelopAsset = "library",
    AvatarAsset = "catalog",
    PlaceAsset = "games",
    Badge = "badges",
    Pass = "game-pass"
}

return Settings