------------------------------------------------------------------------
-- MurlokFury - UI/TalentTab.lua
-- Talent tab: Hero Talents, Class Talents, Spec Talents
-- Reads directly from MURLOK_DATA global table
------------------------------------------------------------------------
local AddOnName, NS = ...
local MF = NS.MF
local L = NS.L
local Widgets = NS.Widgets

-- Localize globals
local ipairs = ipairs
local format = string.format
local math_floor = math.floor
local math_abs = math.abs

--------------------------------------------------------------
-- Render a talent section (hero/class/spec)
--------------------------------------------------------------
local function RenderTalentSection(content, talents, headerText, yOffset, sampleSize)
    local y = yOffset

    -- Section header
    Widgets:CreateHeader(content, headerText, y)
    y = y - 22

    if not talents or #talents == 0 then
        Widgets:CreateTextLine(content, L["NO_DATA"], y)
        return y - 18
    end

    for _, talent in ipairs(talents) do
        local count = talent.count or 0
        local pct = talent.percent
        if not pct then
            pct = (sampleSize > 0) and math_floor(count / sampleSize * 100 + 0.5) or 0
        end

        local label = talent.name or "?"
        local value = format("%d/%d  (%.0f%%)", count, sampleSize, pct)

        Widgets:CreateDataRow(content, label, value, y, pct, 200)
        y = y - 18
    end

    return y - 8
end

--------------------------------------------------------------
-- Create talent tab content
--------------------------------------------------------------
local function CreateTalentTab(parent)
    local scrollFrame, content = Widgets:CreateScrollFrame(parent)
    scrollFrame:SetAllPoints(parent)

    local data = MF.data
    if not data then return scrollFrame end

    local sampleSize = (data.meta and data.meta.sampleSize) or 50
    local y = -8

    -- Hero Talents
    y = RenderTalentSection(content, data.heroTalents, L["HERO_TALENTS"], y, sampleSize)

    -- Class Talents
    y = RenderTalentSection(content, data.classTalents, L["CLASS_TALENTS"], y, sampleSize)

    -- Spec Talents
    y = RenderTalentSection(content, data.specTalents, L["SPEC_TALENTS"], y, sampleSize)

    content:SetHeight(math_abs(y) + 20)
    return scrollFrame
end

-- Register tab 1: Talents
NS.RegisterTabCreator(1, CreateTalentTab)
