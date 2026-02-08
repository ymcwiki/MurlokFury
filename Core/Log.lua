local AddOnName, NS = ...
local MF = NS.MF

-- Localize globals
local format = string.format
local date = date

--------------------------------------------------------------
-- Log levels
--------------------------------------------------------------
local LOG_LEVELS = {
    ERROR = 1,
    WARN  = 2,
    INFO  = 3,
    DEBUG = 4,
}

--------------------------------------------------------------
-- MF:Log(level, msg)
-- Logging is disabled by default. Enable via MurlokFuryDB.debugLog = true
--------------------------------------------------------------
function MF:Log(level, msg)
    -- Only ERROR always prints; others require debugLog
    if level ~= "ERROR" then
        if not (self.db and self.db.debugLog) then
            return
        end
    end

    local lvl = LOG_LEVELS[level] or 3
    local prefix = format("|cff00ff00MurlokFury|r [%s]", level)
    print(format("%s %s", prefix, msg))
end
