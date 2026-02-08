------------------------------------------------------------------------
-- MurlokFury - UI/StatTab.lua
-- Stats tab: Secondary stat priority with stat-specific colored bars
-- Also includes Races tab (tab 6)
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
-- Create stats tab content (tab 2)
--------------------------------------------------------------
local function CreateStatTab(parent)
    local scrollFrame, content = Widgets:CreateScrollFrame(parent)
    scrollFrame:SetAllPoints(parent)

    local data = MF.data
    if not data then return scrollFrame end

    local y = -8

    -- Primary stat priority header
    Widgets:CreateHeader(content, L["STAT_PRIORITY"], y)
    y = y - 22

    if data.stats then
        for _, stat in ipairs(data.stats) do
            local name = stat.name or "?"
            local pct = stat.percent or 0
            local avgRating = stat.avgRating or 0
            local barColor = Widgets.STAT_COLORS[name]

            local value = format("%.0f%%  (%s: %d)", pct, L["AVG_RATING"], avgRating)
            Widgets:CreateDataRow(content, name, value, y, pct, 200, barColor)
            y = y - 22
        end
    end

    -- Minor stats
    y = y - 8
    Widgets:CreateHeader(content, L["MINOR_STATS"], y)
    y = y - 22

    if data.minorStats then
        for _, stat in ipairs(data.minorStats) do
            local name = stat.name or "?"
            local pct = stat.percent or 0
            local avgRating = stat.avgRating or 0

            local value = format("%.0f%%  (%s: %d)", pct, L["AVG_RATING"], avgRating)
            Widgets:CreateDataRow(content, name, value, y, pct, 200)
            y = y - 22
        end
    end

    content:SetHeight(math_abs(y) + 20)
    return scrollFrame
end

-- Register tab 2: Stats
NS.RegisterTabCreator(2, CreateStatTab)

--------------------------------------------------------------
-- Create races tab content (tab 6)
--------------------------------------------------------------
local function CreateRacesTab(parent)
    local scrollFrame, content = Widgets:CreateScrollFrame(parent)
    scrollFrame:SetAllPoints(parent)

    local data = MF.data
    if not data or not data.races then return scrollFrame end

    local sampleSize = (data.meta and data.meta.sampleSize) or 50
    local y = -8

    Widgets:CreateHeader(content, L["RACE_DISTRIBUTION"], y)
    y = y - 22

    for _, race in ipairs(data.races) do
        local count = race.count or 0
        local pct = race.percent or 0
        local label = race.name or "?"
        local value = format("%d  (%.0f%%)", count, pct)

        Widgets:CreateDataRow(content, label, value, y, pct, 200)
        y = y - 18
    end

    content:SetHeight(math_abs(y) + 20)
    return scrollFrame
end

-- Register tab 6: Races
NS.RegisterTabCreator(6, CreateRacesTab)
