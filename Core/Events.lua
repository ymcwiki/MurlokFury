local AddOnName, NS = ...
local MF = NS.MF

-- Localize globals
local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown

--------------------------------------------------------------
-- Event frame
--------------------------------------------------------------
local eventFrame = CreateFrame("Frame")
local eventHandlers = {}

eventFrame:SetScript("OnEvent", function(self, event, ...)
    local handler = eventHandlers[event]
    if handler then
        handler(event, ...)
    end
end)

--------------------------------------------------------------
-- Public API: RegisterEvent / UnregisterEvent
--------------------------------------------------------------
function MF:RegisterEvent(event, handler)
    eventHandlers[event] = handler
    eventFrame:RegisterEvent(event)
end

function MF:UnregisterEvent(event)
    eventHandlers[event] = nil
    eventFrame:UnregisterEvent(event)
end

--------------------------------------------------------------
-- Combat lockdown guard
--------------------------------------------------------------
function MF:IsInCombat()
    return InCombatLockdown()
end

--------------------------------------------------------------
-- Register core lifecycle events
--------------------------------------------------------------
MF:RegisterEvent("PLAYER_LOGIN", function()
    MF:Log("INFO", "Player logged in.")
end)
