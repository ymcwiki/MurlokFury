local AddOnName, NS = ...
local MF = NS.MF

-- Localize globals
local ipairs = ipairs

--------------------------------------------------------------
-- EnchantDisplay module
--------------------------------------------------------------
local EnchantDisplay = {}
NS.EnchantDisplay = EnchantDisplay

function EnchantDisplay:GetEnchantData(slot)
    if not MF.data or not MF.data.enchants then return nil end

    if slot then
        for _, entry in ipairs(MF.data.enchants) do
            if entry.slot == slot then
                return entry
            end
        end
        return nil
    end

    return MF.data.enchants
end

function EnchantDisplay:GetGemData(category)
    if not MF.data or not MF.data.gems then return nil end

    if category then
        for _, entry in ipairs(MF.data.gems) do
            if entry.category == category then
                return entry
            end
        end
        return nil
    end

    return MF.data.gems
end
