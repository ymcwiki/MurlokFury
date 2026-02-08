------------------------------------------------------------------------
-- MurlokFury - UI/EnchantTab.lua
-- Enchants tab (tab 4) and Gems tab (tab 5)
-- Reads directly from MURLOK_DATA global table
------------------------------------------------------------------------
local AddOnName, NS = ...
local MF = NS.MF
local L = NS.L
local Widgets = NS.Widgets

-- Localize globals
local ipairs = ipairs
local format = string.format
local math_abs = math.abs

--------------------------------------------------------------
-- Render a grouped item list (used for both enchants and gems)
--------------------------------------------------------------
local function RenderGroupedList(content, headerText, groups, groupKey, y, sampleSize)
    Widgets:CreateHeader(content, headerText, y)
    y = y - 24

    if not groups or #groups == 0 then
        Widgets:CreateTextLine(content, L["NO_DATA"], y)
        return y - 18
    end

    for _, group in ipairs(groups) do
        local groupName = group[groupKey] or "?"

        -- Group sub-header
        Widgets:CreateSlotLabel(content, groupName, y)
        y = y - 18

        if group.items then
            for _, item in ipairs(group.items) do
                local count = item.count or 0
                local pct = sampleSize > 0 and (count / sampleSize * 100) or 0
                local label = item.name or "?"
                local value = format("%d/%d  (%.0f%%)", count, sampleSize, pct)

                Widgets:CreateDataRow(content, label, value, y, pct, 180)
                y = y - 18
            end
        end

        y = y - 4
    end

    return y
end

--------------------------------------------------------------
-- Create enchants tab content (tab 4)
--------------------------------------------------------------
local function CreateEnchantTab(parent)
    local scrollFrame, content = Widgets:CreateScrollFrame(parent)
    scrollFrame:SetAllPoints(parent)

    local data = MF.data
    if not data then return scrollFrame end

    local sampleSize = (data.meta and data.meta.sampleSize) or 50
    local y = -8

    y = RenderGroupedList(content, L["ENCHANT_RECOMMENDATIONS"], data.enchants, "slot", y, sampleSize)

    content:SetHeight(math_abs(y) + 20)
    return scrollFrame
end

-- Register tab 4: Enchants
NS.RegisterTabCreator(4, CreateEnchantTab)

--------------------------------------------------------------
-- Create gems tab content (tab 5)
--------------------------------------------------------------
local function CreateGemsTab(parent)
    local scrollFrame, content = Widgets:CreateScrollFrame(parent)
    scrollFrame:SetAllPoints(parent)

    local data = MF.data
    if not data then return scrollFrame end

    local sampleSize = (data.meta and data.meta.sampleSize) or 50
    local y = -8

    y = RenderGroupedList(content, L["GEM_RECOMMENDATIONS"], data.gems, "category", y, sampleSize)

    content:SetHeight(math_abs(y) + 20)
    return scrollFrame
end

-- Register tab 5: Gems
NS.RegisterTabCreator(5, CreateGemsTab)
