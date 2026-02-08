local AddOnName, NS = ...
local L = NS.L

-- Only override if client locale is zhCN
if GetLocale() ~= "zhCN" then return end

-- General
L["FURY_WARRIOR_MP"] = "狂怒战士 M+"
L["DATA_UPDATED"] = "数据更新: %s"
L["NO_DATA"] = "暂无数据"
L["SAMPLE_SIZE"] = "样本: Top %d 玩家"

-- Tabs
L["TAB_TALENTS"] = "天赋"
L["TAB_STATS"] = "属性"
L["TAB_GEAR"] = "装备"
L["TAB_ENCHANTS"] = "附魔"
L["TAB_GEMS"] = "宝石"
L["TAB_RACES"] = "种族"

-- Talent sections
L["HERO_TALENTS"] = "英雄天赋"
L["CLASS_TALENTS"] = "职业天赋"
L["SPEC_TALENTS"] = "专精天赋"

-- Stats
L["STAT_PRIORITY"] = "次要属性优先级"
L["MINOR_STATS"] = "次要属性"
L["AVG_RATING"] = "平均等级"

-- Gear
L["BIS_GEAR"] = "最佳装备"

-- Enchants
L["ENCHANT_RECOMMENDATIONS"] = "附魔推荐"

-- Gems
L["GEM_RECOMMENDATIONS"] = "宝石推荐"

-- Races
L["RACE_DISTRIBUTION"] = "种族分布"

-- Slash commands
L["CMD_HELP"] = "命令:"
L["CMD_SHOW"] = "/mf - 切换面板显示"
L["CMD_DEBUG"] = "/mf debug - 切换调试日志"
L["CMD_RESET"] = "/mf reset - 重置面板位置"
L["DEBUG_ON"] = "调试日志已开启"
L["DEBUG_OFF"] = "调试日志已关闭"
L["POSITION_RESET"] = "面板位置已重置"
