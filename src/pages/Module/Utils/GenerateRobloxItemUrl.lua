---@class GenerateRobloxItemUrlModule
local Module = {}

---@type SettingsModule
local Settings = mw.loadData("Module:Settings")

---Format a name for an item URL for SEO purposes.
---@param name string
---@return string
function Module.FormatRobloxItemNameForSeo(name)
    local NewName = name:gsub("'", ""):gsub("%W", "-"):gsub("^-+", ""):gsub("-+$", "")

    local LowerCaseName = NewName:lower()
    if LowerCaseName:match("^com%d$") or LowerCaseName:match("^lpt%d$") or LowerCaseName == "aux" or LowerCaseName == "prt" or LowerCaseName == "nul" or LowerCaseName == "con" or LowerCaseName == "bin" or LowerCaseName == "" then
        NewName = "unnamed"
    end

    return NewName
end

---Get an item URL by it's itemType and itemId.
---@param itemType "Bundle" | "DevelopAsset" | "AvatarAsset" | "PlaceAsset" | "Badge" | "Pass"
---@param itemId number
---@param itemName number | void
---@return string
function Module.GenerateRobloxItemUrl(itemType, itemId, itemName)
    local ItemTypeInUrl = Settings.RobloxItemTypeToItemTypeInUrl[itemType] or "library"
    local ItemUrl = ("%s/%s/%s"):format(Settings.RobloxUrl, ItemTypeInUrl, itemId)

    if itemName ~= nil then
        ItemUrl = ("%s/%s"):format(ItemUrl, Module.FormatRobloxItemNameForSeo(itemName))
    end

    return ItemUrl
end

return Module