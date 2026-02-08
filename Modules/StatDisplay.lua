local AddOnName, NS = ...
local MF = NS.MF

--------------------------------------------------------------
-- StatDisplay module
--------------------------------------------------------------
local StatDisplay = {}
NS.StatDisplay = StatDisplay

function StatDisplay:GetStatData()
    if not MF.data then return nil end
    return {
        stats = MF.data.stats,
        minorStats = MF.data.minorStats,
    }
end
