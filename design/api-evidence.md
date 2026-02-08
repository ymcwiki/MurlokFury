# MurlokFury - API 证据清单

> 版本: 1.0.0
> 日期: 2026-02-08

---

## 1. 概述

MurlokFury 是纯 L0 插件（静态数据展示），使用的 API 均为基础 UI 框架 API，不涉及任何战斗数据或 Secret Values。

---

## 2. 必需 API 清单

### 2.1 Frame 创建与管理

| API | 用途 | 风险等级 |
|-----|------|----------|
| `CreateFrame(type, name, parent, template)` | 创建主面板、Tab 按钮、内容容器 | L0 |

```
/api 验证: /api Widget search CreateFrame
源码验证: Gethe/wow-ui-source (live) -> Interface/AddOns/Blizzard_APIDocumentation/
Wiki: https://warcraft.wiki.gg/wiki/API_CreateFrame
状态: [已确认] -- 基础 Widget API，12.0 未变更
```

### 2.2 Frame 定位与尺寸

| API | 用途 | 风险等级 |
|-----|------|----------|
| `frame:SetPoint(point, relativeTo, relativePoint, x, y)` | 设置框架锚点定位 | L0 |
| `frame:SetSize(width, height)` | 设置框架尺寸 | L0 |
| `frame:SetMovable(bool)` | 启用框架拖拽 | L0 |
| `frame:EnableMouse(bool)` | 启用鼠标交互 | L0 |
| `frame:RegisterForDrag(button)` | 注册拖拽按钮 | L0 |
| `frame:SetScript("OnDragStart", fn)` | 拖拽开始回调 | L0 |
| `frame:SetScript("OnDragStop", fn)` | 拖拽结束回调 | L0 |
| `frame:StartMoving()` | 开始移动 | L0 |
| `frame:StopMovingOrSizing()` | 停止移动 | L0 |
| `frame:SetClampedToScreen(bool)` | 限制在屏幕内 | L0 |

```
/api 验证: /api Widget search SetPoint
源码验证: Gethe/wow-ui-source (live) -> Widget API (Region)
Wiki: https://warcraft.wiki.gg/wiki/API_Region_SetPoint
状态: [已确认] -- 基础 Widget API
```

### 2.3 FontString (文本显示)

| API | 用途 | 风险等级 |
|-----|------|----------|
| `frame:CreateFontString(name, layer, template)` | 创建文本显示元素 | L0 |
| `fontString:SetText(text)` | 设置显示文本 | L0 |
| `fontString:SetFont(font, size, flags)` | 设置字体 | L0 |
| `fontString:SetTextColor(r, g, b, a)` | 设置文本颜色 | L0 |
| `fontString:SetJustifyH(justify)` | 设置水平对齐 | L0 |
| `fontString:SetJustifyV(justify)` | 设置垂直对齐 | L0 |
| `fontString:SetWordWrap(bool)` | 设置自动换行 | L0 |

```
/api 验证: /api Widget search FontString
源码验证: Gethe/wow-ui-source (live) -> Widget API (FontString)
Wiki: https://warcraft.wiki.gg/wiki/UIOBJECT_FontString
状态: [已确认] -- 基础 Widget API，12.0 对 secret value 的 SetText 有新行为，
       但本插件传入的都是预置字符串，不涉及 secret values
```

### 2.4 Texture (纹理/背景)

| API | 用途 | 风险等级 |
|-----|------|----------|
| `frame:CreateTexture(name, layer)` | 创建纹理元素 | L0 |
| `texture:SetTexture(path)` | 设置纹理图片 | L0 |
| `texture:SetColorTexture(r, g, b, a)` | 设置纯色纹理 | L0 |
| `texture:SetAllPoints(frame)` | 覆盖整个框架 | L0 |

```
/api 验证: /api Widget search Texture
源码验证: Gethe/wow-ui-source (live) -> Widget API (Texture)
Wiki: https://warcraft.wiki.gg/wiki/UIOBJECT_Texture
状态: [已确认]
```

### 2.5 ScrollFrame (滚动框架)

| API | 用途 | 风险等级 |
|-----|------|----------|
| `CreateFrame("ScrollFrame", name, parent, "UIPanelScrollFrameTemplate")` | 创建可滚动内容区域 | L0 |
| `scrollFrame:SetScrollChild(child)` | 设置滚动内容 | L0 |

```
/api 验证: /api Widget search ScrollFrame
源码验证: Gethe/wow-ui-source (live) -> Interface/AddOns/Blizzard_SharedXML/
Wiki: https://warcraft.wiki.gg/wiki/UIOBJECT_ScrollFrame
状态: [已确认] -- UIPanelScrollFrameTemplate 在 12.0 中仍可用
       注意: 12.0 也提供了新的 ScrollBox/ScrollBar 系统，但传统模板仍兼容
```

### 2.6 Button (按钮 -- Tab 切换)

| API | 用途 | 风险等级 |
|-----|------|----------|
| `CreateFrame("Button", name, parent, template)` | 创建 Tab 按钮 | L0 |
| `button:SetText(text)` | 设置按钮文本 | L0 |
| `button:SetScript("OnClick", fn)` | 点击事件回调 | L0 |
| `button:SetNormalTexture(path)` | 设置正常态纹理 | L0 |
| `button:SetHighlightTexture(path)` | 设置高亮态纹理 | L0 |
| `button:SetPushedTexture(path)` | 设置按下态纹理 | L0 |

```
/api 验证: /api Widget search Button
源码验证: Gethe/wow-ui-source (live) -> Widget API (Button)
Wiki: https://warcraft.wiki.gg/wiki/UIOBJECT_Button
状态: [已确认]
```

### 2.7 事件系统

| API | 用途 | 风险等级 |
|-----|------|----------|
| `frame:RegisterEvent("ADDON_LOADED")` | 注册插件加载事件 | L0 |
| `frame:SetScript("OnEvent", fn)` | 设置事件处理函数 | L0 |
| `frame:UnregisterEvent(event)` | 取消事件注册 | L0 |

```
/api 验证: /api Events search ADDON_LOADED
源码验证: Gethe/wow-ui-source (live) -> 所有官方插件的初始化模式
Wiki: https://warcraft.wiki.gg/wiki/ADDON_LOADED
状态: [已确认] -- ADDON_LOADED 在 12.0 中未变更
```

### 2.8 Slash 命令

| API | 用途 | 风险等级 |
|-----|------|----------|
| `SLASH_MURLOKFURY1 = "/mf"` | 注册短命令 | L0 |
| `SLASH_MURLOKFURY2 = "/murlokfury"` | 注册全名命令 | L0 |
| `SlashCmdList["MURLOKFURY"] = function(msg) end` | 命令处理函数 | L0 |

```
/api 验证: /api search SlashCmdList
源码验证: Gethe/wow-ui-source (live) -> Interface/AddOns/Blizzard_ChatFrame/
Wiki: https://warcraft.wiki.gg/wiki/Creating_a_slash_command
状态: [已确认] -- 标准 Slash 命令注册方式，12.0 未变更
```

### 2.9 SavedVariables

| API | 用途 | 风险等级 |
|-----|------|----------|
| `.toc: ## SavedVariables: MurlokFuryDB` | 声明持久化变量 | L0 |

```
/api 验证: N/A (TOC 声明)
源码验证: Gethe/wow-ui-source (live) -> 所有官方插件的 .toc 文件
Wiki: https://warcraft.wiki.gg/wiki/SavedVariables
状态: [已确认] -- 标准机制
```

### 2.10 显隐控制

| API | 用途 | 风险等级 |
|-----|------|----------|
| `frame:Show()` | 显示框架 | L0 |
| `frame:Hide()` | 隐藏框架 | L0 |
| `frame:IsShown()` | 检查是否显示 | L0 |
| `frame:SetShown(bool)` | 切换显示状态 | L0 |

```
/api 验证: /api Widget search Show
源码验证: Widget API (ScriptObject)
Wiki: https://warcraft.wiki.gg/wiki/API_Frame_Show
状态: [已确认]
```

### 2.11 背景与边框模板

| API / 模板 | 用途 | 风险等级 |
|------------|------|----------|
| `"BackdropTemplate"` | 框架背景和边框 | L0 |
| `frame:SetBackdrop(backdropInfo)` | 设置背景信息 (Mixin) | L0 |
| `frame:SetBackdropColor(r, g, b, a)` | 设置背景颜色 | L0 |
| `frame:SetBackdropBorderColor(r, g, b, a)` | 设置边框颜色 | L0 |

```
/api 验证: /api search BackdropTemplate
源码验证: Gethe/wow-ui-source (live) -> Interface/AddOns/Blizzard_SharedXML/Backdrop.lua
Wiki: https://warcraft.wiki.gg/wiki/BackdropTemplate
状态: [已确认] -- BackdropTemplate 从 9.0 起取代 SetBackdrop 直接调用，12.0 仍可用
```

### 2.12 Addon 信息显示

| API | 用途 | 风险等级 |
|-----|------|----------|
| `C_AddOns.GetAddOnMetadata(name, field)` | 获取插件版本号等元数据 | L0 |

```
/api 验证: /api C_AddOns search GetAddOnMetadata
源码验证: Gethe/wow-ui-source (live) -> Blizzard_APIDocumentationGenerated/AddOnsDocumentation.lua
Wiki: https://warcraft.wiki.gg/wiki/API_C_AddOns.GetAddOnMetadata
状态: [已确认] -- 12.0 中从全局函数 GetAddOnMetadata 迁移到 C_AddOns 命名空间
```

---

## 3. 不使用的 API 类别（明确排除）

| API 类别 | 原因 |
|----------|------|
| 战斗 API (UnitHealth, UnitPower 等) | 不涉及战斗数据 |
| Secret Values API (issecretvalue 等) | 不处理 secret values |
| C_CombatLog | 不解析战斗日志 |
| C_ChatInfo.SendAddonMessage | 不做插件通信 |
| GameTooltip:SetHyperlink() | v1.0 不做物品链接预览 |
| C_Traits / C_ClassTalents | 不读取玩家当前天赋 |
| C_Container | 不读取背包数据 |
| GetInventoryItemLink | 不读取装备数据 |

---

## 4. 合规确认

- [x] 所有 API 均为 L0 层级（纯 UI 框架操作）
- [x] 不读取任何战斗状态数据
- [x] 不处理 Secret Values
- [x] 不在战斗中做任何数据处理
- [x] 不使用 addon 通信
- [x] Interface 版本声明为 120000
- [x] 符合 Blizzard 插件开发 8 条政策
