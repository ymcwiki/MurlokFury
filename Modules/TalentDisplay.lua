local AddOnName, NS = ...
local MF = NS.MF

-- Localize globals
local ipairs = ipairs

--------------------------------------------------------------
-- TalentDisplay module
--------------------------------------------------------------
local TalentDisplay = {}
NS.TalentDisplay = TalentDisplay

function TalentDisplay:GetHeroTalents()
    if not MF.data then return nil end
    return MF.data.heroTalents
end

function TalentDisplay:GetClassTalents()
    if not MF.data then return nil end
    return MF.data.classTalents
end

function TalentDisplay:GetSpecTalents()
    if not MF.data then return nil end
    return MF.data.specTalents
end

function TalentDisplay:GetTalentData()
    if not MF.data then return nil end
    return {
        heroTalents = MF.data.heroTalents,
        classTalents = MF.data.classTalents,
        specTalents = MF.data.specTalents,
    }
end
