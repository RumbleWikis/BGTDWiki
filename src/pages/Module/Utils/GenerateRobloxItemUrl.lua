---@class GenerateRobloxItemUrlModule
local Module = {}

---@type SettingsModule
local Settings = mw.loadData("Module:Settings")

---Get an item URL by it's itemType and itemId.
---@param itemType "Bundle" | "DevelopAsset" | "AvatarAsset" | "PlaceAsset" | "Badge" | "Pass"
---@param itemId number
function Module.GenerateRobloxItemUrl(itemType, itemId)
    local ItemTypeInUrl = Settings.RobloxItemTypeToItemTypeInUrl[itemType] or "library"
    return Settings.RobloxUrl:format(ItemTypeInUrl, itemId)
end

return Module