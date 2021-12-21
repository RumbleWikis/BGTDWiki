---@class GenerateRobloxItemUrlModule
local Module = {}

---@type SettingsModule
local Settings = mw.loadData("Module:Settings")

---Format a name for an item URL for SEO purposes.
---@param name string
---@return string
function Module._FormatRobloxItemNameForSeo(name)
    local NewName = name:gsub("'", ""):gsub("%W", "-"):gsub("^-+", ""):gsub("-+$", "")

    local LowerCaseName = NewName:lower()
    if LowerCaseName:match("^com%d$") or LowerCaseName:match("^lpt%d$") or LowerCaseName == "aux" or LowerCaseName == "prt" or LowerCaseName == "nul" or LowerCaseName == "con" or LowerCaseName == "bin" or LowerCaseName == "" then
        NewName = "unnamed"
    end

    return NewName
end

---Get an item URL by it's itemType and itemId. If `itemName` is given, it will transform the name into SEO-appropriate.
---@param itemType "Bundle" | "DevelopAsset" | "AvatarAsset" | "PlaceAsset" | "Badge" | "Pass"
---@param itemId number
---@param itemName number | void
---@return string
function Module._GenerateRobloxItemUrl(itemType, itemId, itemName)
    local ItemTypeInUrl = Settings.RobloxItemTypeToItemTypeInUrl[itemType] or "library"
    local ItemUrl = ("%s/%s/%s"):format(Settings.RobloxUrl, ItemTypeInUrl, itemId)

    if itemName ~= nil then
        ItemUrl = ("%s/%s"):format(ItemUrl, Module._FormatRobloxItemNameForSeo(itemName))
    end

    return ItemUrl
end

---Get an item URL by it's itemType and itemId. If `itemName` is given, it will transform the name into SEO-appropriate.
---@param frame Frame
---@return string
function Module.GenerateRobloxItemUrl(frame)
    return Module._GenerateRobloxItemUrl(frame.args[1], frame.args[2], frame.args[3])
end

return Module