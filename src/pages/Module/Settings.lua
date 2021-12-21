---@class SettingsModule
local Settings = {}

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