------------------------------------------------------------------------
-- MurlokFury - UI/Widgets.lua
-- Reusable widget factory functions for all UI components
------------------------------------------------------------------------
local AddOnName, NS = ...
local MF = NS.MF

-- Localize globals
local CreateFrame = CreateFrame
local UIParent = UIParent
local InCombatLockdown = InCombatLockdown
local pairs, ipairs = pairs, ipairs
local format = string.format
local max, min = math.max, math.min
local unpack = unpack

--------------------------------------------------------------
-- Widget factory
--------------------------------------------------------------
local Widgets = {}
NS.Widgets = Widgets

-- Color constants
Widgets.COLORS = {
    BACKGROUND = { 0.06, 0.06, 0.06, 0.95 },
    BORDER     = { 0.3, 0.3, 0.3, 1 },
    TITLE      = { 0, 1, 0, 1 },          -- #00ff00
    HEADER     = { 1, 0.82, 0, 1 },       -- #ffd100
    TEXT       = { 1, 1, 1, 1 },           -- #ffffff
    SUBTEXT    = { 0.6, 0.6, 0.6, 1 },
    BAR_BG     = { 0.15, 0.15, 0.15, 1 },
    BAR_GREEN  = { 0, 0.7, 0, 0.8 },
    TAB_ACTIVE   = { 0, 0.5, 0, 1 },
    TAB_INACTIVE = { 0.15, 0.15, 0.15, 1 },
    TAB_HOVER    = { 0.25, 0.25, 0.25, 1 },
    SLOT_HEADER  = { 0.6, 0.8, 1, 1 },
}

-- Stat-specific colors
Widgets.STAT_COLORS = {
    ["Mastery"]         = { 0.64, 0.21, 0.93, 0.8 },  -- Purple
    ["Haste"]           = { 1.00, 0.82, 0.00, 0.8 },  -- Yellow
    ["Critical Strike"]  = { 0.90, 0.20, 0.20, 0.8 },  -- Red
    ["Versatility"]     = { 0.00, 0.80, 0.00, 0.8 },  -- Green
}

-- Font sizes
Widgets.FONT_LARGE  = 14
Widgets.FONT_NORMAL = 12
Widgets.FONT_SMALL  = 10

-- Standard font path
Widgets.FONT = "Fonts\\FRIZQT__.TTF"

--------------------------------------------------------------
-- NS.CreateMainFrame(name, width, height)
-- Creates a draggable main window with backdrop and close button
--------------------------------------------------------------
function NS.CreateMainFrame(name, width, height)
    if InCombatLockdown() then return nil end

    local f = CreateFrame("Frame", name, UIParent, "BackdropTemplate")
    f:SetSize(width, height)
    f:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    f:SetFrameStrata("MEDIUM")
    f:SetToplevel(true)
    f:SetClampedToScreen(true)

    f:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
    })
    f:SetBackdropColor(unpack(Widgets.COLORS.BACKGROUND))
    f:SetBackdropBorderColor(unpack(Widgets.COLORS.BORDER))

    -- Make draggable
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", function(self)
        if not InCombatLockdown() then
            self:StartMoving()
        end
    end)
    f:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        local point, _, relativePoint, xOfs, yOfs = self:GetPoint()
        if MF.db then
            MF.db.position.point = point
            MF.db.position.relativePoint = relativePoint
            MF.db.position.xOfs = xOfs
            MF.db.position.yOfs = yOfs
        end
    end)

    -- Close button
    local closeBtn = CreateFrame("Button", nil, f, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", f, "TOPRIGHT", -2, -2)
    closeBtn:SetScript("OnClick", function()
        f:Hide()
    end)

    return f
end

--------------------------------------------------------------
-- Widgets:CreateHeader(parent, text, offsetY)
-- Section header with gold text
--------------------------------------------------------------
function Widgets:CreateHeader(parent, text, offsetY)
    local fs = parent:CreateFontString(nil, "OVERLAY")
    fs:SetFont(self.FONT, self.FONT_LARGE, "OUTLINE")
    fs:SetTextColor(unpack(self.COLORS.HEADER))
    fs:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, offsetY or 0)
    fs:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -10, offsetY or 0)
    fs:SetJustifyH("LEFT")
    fs:SetText(text)

    -- Separator line below header
    local line = parent:CreateTexture(nil, "ARTWORK")
    line:SetHeight(1)
    line:SetPoint("TOPLEFT", fs, "BOTTOMLEFT", 0, -2)
    line:SetPoint("TOPRIGHT", fs, "BOTTOMRIGHT", 0, -2)
    line:SetColorTexture(0.4, 0.4, 0.4, 0.6)

    return fs
end

--------------------------------------------------------------
-- Widgets:CreateTextLine(parent, text, offsetY)
-- Normal text line
--------------------------------------------------------------
function Widgets:CreateTextLine(parent, text, offsetY)
    local fs = parent:CreateFontString(nil, "OVERLAY")
    fs:SetFont(self.FONT, self.FONT_NORMAL)
    fs:SetTextColor(unpack(self.COLORS.TEXT))
    fs:SetPoint("TOPLEFT", parent, "TOPLEFT", 15, offsetY or 0)
    fs:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -15, offsetY or 0)
    fs:SetJustifyH("LEFT")
    fs:SetWordWrap(true)
    if text then
        fs:SetText(text)
    end
    return fs
end

--------------------------------------------------------------
-- Widgets:CreateSlotLabel(parent, text, offsetY)
-- Slot/category sub-header (blue-white text)
--------------------------------------------------------------
function Widgets:CreateSlotLabel(parent, text, offsetY)
    local fs = parent:CreateFontString(nil, "OVERLAY")
    fs:SetFont(self.FONT, self.FONT_NORMAL, "OUTLINE")
    fs:SetTextColor(unpack(self.COLORS.SLOT_HEADER))
    fs:SetPoint("TOPLEFT", parent, "TOPLEFT", 12, offsetY or 0)
    fs:SetJustifyH("LEFT")
    fs:SetText(text)
    return fs
end

--------------------------------------------------------------
-- Widgets:CreateBar(parent, width, height)
-- Percentage bar with fill
--------------------------------------------------------------
function Widgets:CreateBar(parent, width, height)
    local bar = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    bar:SetSize(width, height)
    bar:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
    })
    bar:SetBackdropColor(unpack(self.COLORS.BAR_BG))

    local fill = bar:CreateTexture(nil, "ARTWORK")
    fill:SetTexture("Interface\\Buttons\\WHITE8x8")
    fill:SetVertexColor(unpack(self.COLORS.BAR_GREEN))
    fill:SetPoint("TOPLEFT")
    fill:SetPoint("BOTTOMLEFT")
    fill:SetWidth(1)
    bar.fill = fill

    function bar:SetPercent(pct)
        local w = self:GetWidth() * (min(max(pct, 0), 100) / 100)
        if w < 1 then w = 1 end
        self.fill:SetWidth(w)
    end

    function bar:SetBarColor(r, g, b, a)
        self.fill:SetVertexColor(r, g, b, a or 0.8)
    end

    return bar
end

--------------------------------------------------------------
-- Widgets:CreateTabButton(parent, id, text, onClick)
-- Tab navigation button
--------------------------------------------------------------
function Widgets:CreateTabButton(parent, id, text, onClick)
    local btn = CreateFrame("Button", nil, parent, "BackdropTemplate")
    btn:SetSize(90, 26)
    btn:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        edgeSize = 1,
    })
    btn:SetBackdropColor(unpack(self.COLORS.TAB_INACTIVE))
    btn:SetBackdropBorderColor(unpack(self.COLORS.BORDER))

    local label = btn:CreateFontString(nil, "OVERLAY")
    label:SetFont(self.FONT, self.FONT_SMALL)
    label:SetTextColor(unpack(self.COLORS.TEXT))
    label:SetPoint("CENTER")
    label:SetText(text)
    btn.label = label
    btn.tabID = id

    btn:SetScript("OnClick", function(self)
        if onClick then onClick(self.tabID) end
    end)

    btn:SetScript("OnEnter", function(self)
        if not self.isActive then
            self:SetBackdropColor(unpack(Widgets.COLORS.TAB_HOVER))
        end
    end)
    btn:SetScript("OnLeave", function(self)
        if not self.isActive then
            self:SetBackdropColor(unpack(Widgets.COLORS.TAB_INACTIVE))
        end
    end)

    function btn:SetActive(active)
        self.isActive = active
        if active then
            self:SetBackdropColor(unpack(Widgets.COLORS.TAB_ACTIVE))
            self.label:SetTextColor(1, 1, 1, 1)
        else
            self:SetBackdropColor(unpack(Widgets.COLORS.TAB_INACTIVE))
            self.label:SetTextColor(0.8, 0.8, 0.8, 1)
        end
    end

    return btn
end

--------------------------------------------------------------
-- Widgets:CreateScrollFrame(parent)
-- Scroll frame with content child
--------------------------------------------------------------
function Widgets:CreateScrollFrame(parent)
    local scrollFrame = CreateFrame("ScrollFrame", nil, parent, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)
    scrollFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -24, 0)

    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetSize(scrollFrame:GetWidth(), 1)
    scrollFrame:SetScrollChild(content)

    scrollFrame:SetScript("OnSizeChanged", function(self, w, h)
        content:SetWidth(w)
    end)

    return scrollFrame, content
end

--------------------------------------------------------------
-- Widgets:CreateDataRow(parent, label, value, pct, barWidth, barColor)
-- Data row: label text + value text + optional bar
--------------------------------------------------------------
function Widgets:CreateDataRow(parent, label, value, offsetY, pct, barWidth, barColor)
    -- Label
    local labelFS = parent:CreateFontString(nil, "OVERLAY")
    labelFS:SetFont(self.FONT, self.FONT_NORMAL)
    labelFS:SetTextColor(unpack(self.COLORS.TEXT))
    labelFS:SetPoint("TOPLEFT", parent, "TOPLEFT", 20, offsetY)
    labelFS:SetWidth(200)
    labelFS:SetJustifyH("LEFT")
    labelFS:SetText(label)

    -- Value (right-aligned)
    local valueFS = parent:CreateFontString(nil, "OVERLAY")
    valueFS:SetFont(self.FONT, self.FONT_SMALL)
    valueFS:SetTextColor(unpack(self.COLORS.SUBTEXT))
    valueFS:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -30, offsetY)
    valueFS:SetJustifyH("RIGHT")
    valueFS:SetText(value)

    -- Bar (between label and value)
    if pct and pct > 0 and barWidth then
        local bar = self:CreateBar(parent, barWidth, 8)
        bar:SetPoint("TOPLEFT", parent, "TOPLEFT", 225, offsetY - 2)
        bar:SetPercent(pct)
        if barColor then
            bar:SetBarColor(unpack(barColor))
        end
        return labelFS, valueFS, bar
    end

    return labelFS, valueFS
end
