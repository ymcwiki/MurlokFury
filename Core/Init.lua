local AddOnName, NS = ...

-- Localize globals
local pairs = pairs
local type = type
local print = print

--------------------------------------------------------------
-- Core engine object
--------------------------------------------------------------
local MF = {}
NS.MF = MF
MF.name = AddOnName
MF.version = "1.0.0"

--------------------------------------------------------------
-- Deep copy defaults into saved variables
--------------------------------------------------------------
local function CopyDefaults(src, dst)
    for k, v in pairs(src) do
        if type(v) == "table" then
            if type(dst[k]) ~= "table" then
                dst[k] = {}
            end
            CopyDefaults(v, dst[k])
        elseif dst[k] == nil then
            dst[k] = v
        end
    end
end

--------------------------------------------------------------
-- Initialize saved variables and validate data
--------------------------------------------------------------
function MF:Init()
    -- Initialize or load SavedVariables
    if not MurlokFuryDB then
        MurlokFuryDB = {}
    end
    CopyDefaults(NS.defaults, MurlokFuryDB)

    -- Store reference for easy access
    self.db = MurlokFuryDB

    -- Validate that MURLOK_DATA exists
    if not MURLOK_DATA then
        self:PrintError("MURLOK_DATA not found. Data file may be missing.")
        return false
    end

    self.data = MURLOK_DATA
    return true
end

--------------------------------------------------------------
-- Convenience print
--------------------------------------------------------------
function MF:Print(msg)
    print("|cff00ff00MurlokFury|r: " .. msg)
end

function MF:PrintError(msg)
    print("|cffff0000MurlokFury Error|r: " .. msg)
end
