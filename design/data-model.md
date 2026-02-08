# MurlokFury - 数据模型设计

> 版本: 1.0.0
> 日期: 2026-02-08

---

## 1. 数据文件概述

数据文件 `Data/MurlokData.lua` 由外部 Python 脚本生成，包含一个全局 Lua table `MURLOK_DATA`，供插件在游戏内读取。

---

## 2. 完整 Lua Table 结构定义

```lua
MURLOK_DATA = {
    -- 元数据
    meta = {
        source = "https://murlok.io/warrior/fury/m+",
        updated = "2026-02-08T12:00:00Z",  -- ISO 8601 格式
        sampleSize = 50,                    -- 统计样本人数
        class = "Warrior",
        spec = "Fury",
        content = "M+",
    },

    -- 英雄天赋 (Hero Talents)
    heroTalents = {
        -- name: 英雄天赋路线名称
        -- count: 使用人数
        -- percent: 使用百分比
        { name = "Mountain Thane", count = 47, percent = 94.0 },
        { name = "Slayer", count = 3, percent = 6.0 },
    },

    -- 职业天赋 (Class Talents)
    classTalents = {
        -- name: 天赋名称
        -- count: 使用人数
        -- percent: 使用百分比
        { name = "Berserker Stance", count = 50, percent = 100.0 },
        { name = "War Machine", count = 50, percent = 100.0 },
        -- ... 更多天赋
    },

    -- 专精天赋 (Spec Talents)
    specTalents = {
        { name = "Bloodthirst", count = 50, percent = 100.0 },
        { name = "Raging Blow", count = 50, percent = 100.0 },
        { name = "Rampage", count = 50, percent = 100.0 },
        -- ... 更多天赋
    },

    -- 属性优先级 (Stat Priority)
    stats = {
        -- name: 属性名称
        -- percent: 平均占比 (%)
        -- avgRating: 平均属性等级
        { name = "Mastery", percent = 64.0, avgRating = 466 },
        { name = "Haste", percent = 42.0, avgRating = 471 },
        { name = "Critical Strike", percent = 19.0, avgRating = 145 },
        { name = "Versatility", percent = 16.0, avgRating = 232 },
    },

    -- 次要属性 (Minor Stats)
    minorStats = {
        { name = "Avoidance", percent = 9.0, avgRating = 92 },
        { name = "Leech", percent = 4.0, avgRating = 71 },
    },

    -- BiS 装备 (Best in Slot)
    gear = {
        -- slot: 装备部位
        -- items: 该部位的装备列表（按使用人数降序）
        --   name: 装备名称
        --   count: 使用人数
        {
            slot = "Head",
            items = {
                { name = "Living Weapon's Faceshield", count = 32 },
            },
        },
        {
            slot = "Neck",
            items = {
                { name = "Chrysalis of Sundered Souls", count = 20 },
            },
        },
        {
            slot = "Shoulders",
            items = {
                { name = "Living Weapon's Ramparts", count = 47 },
            },
        },
        {
            slot = "Back",
            items = {
                { name = "Reshii Wraps", count = 50 },
            },
        },
        {
            slot = "Chest",
            items = {
                { name = "Living Weapon's Bulwark", count = 49 },
            },
        },
        {
            slot = "Wrist",
            items = {
                { name = "Everforged Vambraces", count = 46 },
            },
        },
        {
            slot = "Hands",
            items = {
                { name = "Living Weapon's Crushers", count = 39 },
            },
        },
        {
            slot = "Waist",
            items = {
                { name = "Everforged Greatbelt", count = 28 },
            },
        },
        {
            slot = "Legs",
            items = {
                { name = "Living Weapon's Legguards", count = 50 },
            },
        },
        {
            slot = "Feet",
            items = {
                { name = "Interloper's Plated Sabatons", count = 47 },
            },
        },
        {
            slot = "Ring",
            items = {
                { name = "Ring of Earthen Craftsmanship", count = 24 },
                { name = "Signet of the False Accuser", count = 16 },
            },
        },
        {
            slot = "Trinket",
            items = {
                { name = "Astral Antenna", count = 47 },
                { name = "Ara-Kara Sacbrood", count = 30 },
            },
        },
        {
            slot = "Main Hand",
            items = {
                { name = "Photon Sabre Prime", count = 25 },
            },
        },
    },

    -- 附魔 (Enchants)
    enchants = {
        -- slot: 附魔部位
        -- items: 附魔选项列表
        --   name: 附魔名称
        --   count: 使用人数
        {
            slot = "Back",
            items = {
                { name = "Chant of Winged Grace", count = 29 },
            },
        },
        {
            slot = "Chest",
            items = {
                { name = "Crystalline Radiance", count = 50 },
            },
        },
        {
            slot = "Wrist",
            items = {
                { name = "Chant of Armored Avoidance", count = 34 },
            },
        },
        {
            slot = "Feet",
            items = {
                { name = "Defender's March", count = 43 },
            },
        },
        {
            slot = "Ring",
            items = {
                { name = "Radiant Mastery", count = 47 },
            },
        },
        {
            slot = "Main Hand",
            items = {
                { name = "Oathsworn's Tenacity", count = 27 },
            },
        },
        {
            slot = "Off Hand",
            items = {
                { name = "Oathsworn's Tenacity", count = 34 },
            },
        },
        {
            slot = "Legs",
            items = {
                { name = "Defender's Armor Kit", count = 33 },
            },
        },
    },

    -- 宝石 (Gems)
    gems = {
        -- category: 宝石类别
        -- items: 宝石选项列表
        --   name: 宝石名称
        --   count: 使用人数
        {
            category = "Algari Diamond",
            items = {
                { name = "Culminating Blasphemite", count = 43 },
            },
        },
        {
            category = "Fiber",
            items = {
                { name = "Pure Energizing Fiber", count = 25 },
            },
        },
        {
            category = "Prismatic",
            items = {
                { name = "Quick Onyx", count = 63 },
                { name = "Versatile Onyx", count = 59 },
            },
        },
    },

    -- 种族统计 (Races)
    races = {
        -- name: 种族名称
        -- count: 使用人数
        -- percent: 使用百分比
        { name = "Night Elf", count = 26, percent = 52.0 },
        { name = "Tauren", count = 5, percent = 10.0 },
        { name = "Dwarf", count = 4, percent = 8.0 },
        { name = "Void Elf", count = 4, percent = 8.0 },
        { name = "Human", count = 4, percent = 8.0 },
    },
}
```

---

## 3. 字段说明

### 3.1 meta (元数据)

| 字段 | 类型 | 说明 |
|------|------|------|
| source | string | 数据来源 URL |
| updated | string | 数据更新时间 (ISO 8601) |
| sampleSize | number | 统计样本人数 |
| class | string | 职业名称 |
| spec | string | 专精名称 |
| content | string | 内容类型 (M+/Raid/PvP) |

### 3.2 heroTalents / classTalents / specTalents (天赋)

| 字段 | 类型 | 说明 |
|------|------|------|
| name | string | 天赋名称 |
| count | number | 使用该天赋的玩家数 |
| percent | number | 使用百分比 (0-100) |

### 3.3 stats / minorStats (属性)

| 字段 | 类型 | 说明 |
|------|------|------|
| name | string | 属性名称 |
| percent | number | 平均占比 (%) |
| avgRating | number | 平均属性等级 |

### 3.4 gear (装备)

| 字段 | 类型 | 说明 |
|------|------|------|
| slot | string | 装备部位 |
| items | table[] | 装备列表 |
| items[].name | string | 装备名称 |
| items[].count | number | 使用该装备的玩家数 |

### 3.5 enchants (附魔)

| 字段 | 类型 | 说明 |
|------|------|------|
| slot | string | 附魔部位 |
| items | table[] | 附魔选项列表 |
| items[].name | string | 附魔名称 |
| items[].count | number | 使用该附魔的玩家数 |

### 3.6 gems (宝石)

| 字段 | 类型 | 说明 |
|------|------|------|
| category | string | 宝石类别 |
| items | table[] | 宝石选项列表 |
| items[].name | string | 宝石名称 |
| items[].count | number | 使用该宝石的玩家数 |

### 3.7 races (种族)

| 字段 | 类型 | 说明 |
|------|------|------|
| name | string | 种族名称 |
| count | number | 使用人数 |
| percent | number | 使用百分比 (0-100) |

---

## 4. 数据生成规则

1. Python 脚本抓取 murlok.io 页面 HTML
2. 解析各数据表格，提取名称和使用人数
3. 百分比由脚本计算: `percent = (count / sampleSize) * 100`
4. 装备/附魔/宝石按使用人数降序排列
5. 输出为合法的 Lua 语法，可被 WoW 客户端直接加载
6. 文件头部包含注释说明生成时间和来源

---

## 5. 数据更新频率

- 推荐每周更新一次（配合每周 M+ 赛季重置）
- 通过运行 `python3 tools/fetch_murlok.py` 生成新数据
- 重新打包插件后分发
