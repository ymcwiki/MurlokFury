local AddOnName, NS = ...
local MF = NS.MF
local L = NS.L

-- Localize globals
local SlashCmdList = SlashCmdList

--------------------------------------------------------------
-- ADDON_LOADED: entry point
--------------------------------------------------------------
MF:RegisterEvent("ADDON_LOADED", function(event, loadedAddon)
    if loadedAddon ~= AddOnName then return end

    -- Initialize core (SavedVariables + data validation)
    local ok = MF:Init()
    if ok then
        MF:Log("INFO", "Addon loaded successfully.")
    end

    -- Create UI (deferred until first toggle)
    -- NS.MainFrame:Create() will be called on first /mf

    -- Unregister since we only need this once
    MF:UnregisterEvent("ADDON_LOADED")
end)

--------------------------------------------------------------
-- Slash commands: /murlok, /mf
--------------------------------------------------------------
SLASH_MURLOKFURY1 = "/murlok"
SLASH_MURLOKFURY2 = "/mf"

SlashCmdList["MURLOKFURY"] = function(msg)
    local cmd = msg and msg:lower():trim() or ""

    if cmd == "debug" then
        MF.db.debugLog = not MF.db.debugLog
        if MF.db.debugLog then
            MF:Print(L["DEBUG_ON"])
        else
            MF:Print(L["DEBUG_OFF"])
        end
    elseif cmd == "reset" then
        NS.MainFrame:ResetPosition()
        MF:Print(L["POSITION_RESET"])
    elseif cmd == "help" then
        MF:Print(L["CMD_HELP"])
        MF:Print(L["CMD_SHOW"])
        MF:Print(L["CMD_DEBUG"])
        MF:Print(L["CMD_RESET"])
    else
        NS.MainFrame:Toggle()
    end
end
