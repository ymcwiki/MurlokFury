# MurlokFury

A World of Warcraft addon that displays **Fury Warrior Mythic+ meta data** from [murlok.io](https://murlok.io) directly in-game.

Browse the most popular talents, stats, gear, enchants, gems, and race choices used by top M+ Fury Warriors -- without leaving the game.

## Features

- **Talents** -- Hero Talent, Class Talent, and Spec Talent popularity with usage counts
- **Stats** -- Secondary stat priority with color-coded percentage bars
- **Gear** -- Best-in-Slot recommendations for every equipment slot
- **Enchants** -- Enchant recommendations per slot with usage rates
- **Gems** -- Gem recommendations by category (Algari Diamond, Fiber, Prismatic)
- **Races** -- Race distribution among the top-ranked players

Additional features:
- Draggable panel with saved position
- ESC to close
- Auto-hide in combat, auto-show after combat
- English and Simplified Chinese localization
- Data source and update timestamp in the footer

## Requirements

- World of Warcraft 12.0.0 (Midnight) or later

## Installation

1. Download or clone this repository
2. Copy the `MurlokFury` folder into your WoW addons directory:
   ```
   World of Warcraft/_retail_/Interface/AddOns/MurlokFury/
   ```
3. Restart WoW or type `/reload` in-game

## Usage

| Command | Description |
|---------|-------------|
| `/murlok` or `/mf` | Toggle the MurlokFury panel |
| `/mf debug` | Toggle debug logging |
| `/mf reset` | Reset panel position to center |
| `/mf help` | Show available commands |

## Updating Data

The addon ships with a static data snapshot in `Data/MurlokData.lua`. To refresh the data:

1. Run the data fetcher script:
   ```bash
   python3 fetch_murlok.py
   ```
2. The script will overwrite `Data/MurlokData.lua` with fresh data from murlok.io
3. Reload your UI in-game with `/reload`

## Screenshots

*Screenshots will be added after in-game testing.*

## Project Structure

```
MurlokFury/
  MurlokFury.toc          -- Addon metadata and file load order
  MurlokFury.lua           -- Entry point (ADDON_LOADED, slash commands)
  Core/
    Init.lua               -- Core engine, SavedVariables, data validation
    Events.lua             -- Event system and combat lockdown guard
    Log.lua                -- Debug logging (disabled by default)
  Data/
    MurlokData.lua         -- Static data from murlok.io (auto-generated)
    Defaults.lua           -- SavedVariables default values
  Locales/
    enUS.lua               -- English strings
    zhCN.lua               -- Simplified Chinese strings
  Modules/
    TalentDisplay.lua      -- Talent data access layer
    GearDisplay.lua        -- Gear data access layer
    StatDisplay.lua        -- Stat data access layer
    EnchantDisplay.lua     -- Enchant and gem data access layer
  UI/
    Widgets.lua            -- Reusable widget factory (bars, tabs, scroll)
    MainFrame.lua          -- Main panel, tab navigation, footer
    TalentTab.lua          -- Tab 1: Talents
    StatTab.lua            -- Tab 2: Stats + Tab 6: Races
    GearTab.lua            -- Tab 3: Gear
    EnchantTab.lua         -- Tab 4: Enchants + Tab 5: Gems
```

## Known Limitations

- Data is a static snapshot and must be manually refreshed via `fetch_murlok.py`
- Only covers Fury Warrior M+ content (spec and content type are not configurable)
- No minimap button implementation yet (setting exists in defaults)
- Item tooltips are not linked to in-game items (display names only)
- No in-game data refresh capability

## Compliance

This addon is fully compliant with Blizzard's Midnight addon policies:

- **L0 risk level** -- Pure UI display of pre-computed static data
- No combat data reading or real-time analysis
- No Secret Values interaction
- No OnUpdate polling
- No addon communication during combat
- Free, open source, no ads, no in-game donation requests

## License

This project is provided as-is for personal use.
