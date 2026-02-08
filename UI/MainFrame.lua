------------------------------------------------------------------------
-- MurlokFury - UI/MainFrame.lua
-- Main panel: window frame, tab navigation, content area, status bar
-- Also handles slash commands and ADDON_LOADED initialization
------------------------------------------------------------------------
local AddOnName, NS = ...
local MF = NS.MF
local L = NS.L
local Widgets = NS.Widgets

-- Localize globals
local CreateFrame = CreateFrame
local UIParent = UIParent
local InCombatLockdown = InCombatLockdown
local UISpecialFrames = UISpecialFrames
local pairs, ipairs = pairs, ipairs
local format = string.format
local tinsert = table.insert
local unpack = unpack

--------------------------------------------------------------
-- MainFrame module
--------------------------------------------------------------
local MainFrame = {}
NS.MainFrame = MainFrame

local TAB_DEFS = {
    { id = 1, label = L["TAB_TALENTS"] },
    { id = 2, label = L["TAB_STATS"] },
    { id = 3, label = L["TAB_GEAR"] },
    { id = 4, label = L["TAB_ENCHANTS"] },
    { id = 5, label = L["TAB_GEMS"] },
    { id = 6, label = L["TAB_RACES"] },
}

--------------------------------------------------------------
-- Tab content registry
-- Tab-specific files register their creator function here
--------------------------------------------------------------
local tabCreators = {}

function NS.RegisterTabCreator(tabID, creator)
    tabCreators[tabID] = creator
end

--------------------------------------------------------------
-- Create the main panel frame
--------------------------------------------------------------
function MainFrame:Create()
    if self.frame then return self.frame end

    local db = MF.db
    local f = NS.CreateMainFrame("MurlokFuryMainFrame", 700, 500)
    if not f then return nil end

    -- Restore saved position
    local pos = db.position
    f:ClearAllPoints()
    f:SetPoint(pos.point or "CENTER", UIParent, pos.relativePoint or "CENTER", pos.xOfs or 0, pos.yOfs or 0)

    -- Title
    local title = f:CreateFontString(nil, "OVERLAY")
    title:SetFont(Widgets.FONT, Widgets.FONT_LARGE, "OUTLINE")
    title:SetTextColor(unpack(Widgets.COLORS.TITLE))
    title:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -10)
    title:SetText("|cff00ff00MurlokFury|r - Fury Warrior M+ Meta")

    -- Tab bar (below title)
    local tabBarY = -34
    self.tabs = {}
    self.tabContents = {}

    for i, def in ipairs(TAB_DEFS) do
        local btn = Widgets:CreateTabButton(f, def.id, def.label, function(tabID)
            self:SelectTab(tabID)
        end)
        btn:SetPoint("TOPLEFT", f, "TOPLEFT", 10 + (i - 1) * 96, tabBarY)
        self.tabs[def.id] = btn
    end

    -- Content area (below tabs, above footer)
    local contentArea = CreateFrame("Frame", nil, f)
    contentArea:SetPoint("TOPLEFT", f, "TOPLEFT", 8, tabBarY - 32)
    contentArea:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -8, 28)
    self.contentArea = contentArea

    -- Footer left: data source + update time
    local footer = f:CreateFontString(nil, "OVERLAY")
    footer:SetFont(Widgets.FONT, Widgets.FONT_SMALL)
    footer:SetTextColor(unpack(Widgets.COLORS.SUBTEXT))
    footer:SetPoint("BOTTOMLEFT", f, "BOTTOMLEFT", 12, 8)
    local data = MF.data
    if data and data.meta then
        footer:SetText(format("Data from murlok.io  |  Updated: %s  |  Sample: Top %d players",
            data.meta.updated or "?", data.meta.sampleSize or 0))
    end

    -- Register to UISpecialFrames (ESC to close)
    tinsert(UISpecialFrames, "MurlokFuryMainFrame")

    -- Combat auto-hide
    MF:RegisterEvent("PLAYER_REGEN_DISABLED", function()
        if self.frame and self.frame:IsShown() then
            self.frame:Hide()
            self._hiddenByCombat = true
        end
    end)

    MF:RegisterEvent("PLAYER_REGEN_ENABLED", function()
        if self._hiddenByCombat and self.frame then
            self.frame:Show()
            self._hiddenByCombat = false
        end
    end)

    f:Hide()
    self.frame = f

    -- Select the saved or default tab
    self:SelectTab(db.activeTab or 1)

    return f
end

--------------------------------------------------------------
-- Tab switching
--------------------------------------------------------------
function MainFrame:SelectTab(tabID)
    if InCombatLockdown() then return end

    -- Update button visuals
    for id, btn in pairs(self.tabs) do
        btn:SetActive(id == tabID)
    end

    -- Hide all tab content frames
    for _, content in pairs(self.tabContents) do
        content:Hide()
    end

    -- Show or create the selected tab content
    local content = self.tabContents[tabID]
    if not content then
        content = self:CreateTabContent(tabID)
        self.tabContents[tabID] = content
    end
    if content then
        content:Show()
    end

    -- Save active tab
    if MF.db then
        MF.db.activeTab = tabID
    end
end

--------------------------------------------------------------
-- Create tab content (delegates to registered tab creators)
--------------------------------------------------------------
function MainFrame:CreateTabContent(tabID)
    local creator = tabCreators[tabID]
    if creator then
        return creator(self.contentArea)
    end
    return nil
end

--------------------------------------------------------------
-- Toggle visibility
--------------------------------------------------------------
function MainFrame:Toggle()
    if InCombatLockdown() then
        MF:Print("Cannot toggle panel during combat.")
        return
    end
    if not self.frame then
        self:Create()
    end
    if not self.frame then return end

    if self.frame:IsShown() then
        self.frame:Hide()
    else
        self.frame:Show()
    end
end

--------------------------------------------------------------
-- Reset position to center
--------------------------------------------------------------
function MainFrame:ResetPosition()
    if not self.frame or InCombatLockdown() then return end
    local db = MF.db
    db.position.point = "CENTER"
    db.position.relativePoint = "CENTER"
    db.position.xOfs = 0
    db.position.yOfs = 0
    self.frame:ClearAllPoints()
    self.frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
end

-- Note: Slash commands and ADDON_LOADED are handled in MurlokFury.lua (entry point)
