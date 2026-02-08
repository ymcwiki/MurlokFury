------------------------------------------------------------------------
-- MurlokFury - UI/GearTab.lua
-- Gear tab: Best in Slot equipment by slot
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
-- Create gear tab content (tab 3)
--------------------------------------------------------------
local function CreateGearTab(parent)
    local scrollFrame, content = Widgets:CreateScrollFrame(parent)
    scrollFrame:SetAllPoints(parent)

    local data = MF.data
    if not data or not data.gear then return scrollFrame end

    local sampleSize = (data.meta and data.meta.sampleSize) or 50
    local y = -8

    -- Main header
    Widgets:CreateHeader(content, L["BIS_GEAR"], y)
    y = y - 24

    for _, slotData in ipairs(data.gear) do
        -- Slot sub-header
        Widgets:CreateSlotLabel(content, slotData.slot or "?", y)
        y = y - 18

        if slotData.items then
            for _, item in ipairs(slotData.items) do
                local count = item.count or 0
                local pct = sampleSize > 0 and (count / sampleSize * 100) or 0
                local label = item.name or "?"
                local value = format("%d/%d  (%.0f%%)", count, sampleSize, pct)

                Widgets:CreateDataRow(content, label, value, y, pct, 180)
                y = y - 18
            end
        end

        y = y - 6
    end

    content:SetHeight(math_abs(y) + 20)
    return scrollFrame
end

-- Register tab 3: Gear
NS.RegisterTabCreator(3, CreateGearTab)
