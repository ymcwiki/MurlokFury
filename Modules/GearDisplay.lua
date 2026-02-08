local AddOnName, NS = ...
local MF = NS.MF

-- Localize globals
local ipairs = ipairs

--------------------------------------------------------------
-- GearDisplay module
--------------------------------------------------------------
local GearDisplay = {}
NS.GearDisplay = GearDisplay

function GearDisplay:GetGearData(slot)
    if not MF.data or not MF.data.gear then return nil end

    if slot then
        for _, entry in ipairs(MF.data.gear) do
            if entry.slot == slot then
                return entry
            end
        end
        return nil
    end

    return MF.data.gear
end
