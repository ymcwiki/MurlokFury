#!/usr/bin/env python3
"""
MurlokFury Data Fetcher
Scrapes murlok.io for Fury Warrior M+ data and outputs a Lua data file.

Usage:
    python3 fetch_murlok.py

Output:
    ../Data/MurlokData.lua
"""

import re
import os
import sys
from datetime import datetime, timezone

try:
    import requests
    from bs4 import BeautifulSoup
except ImportError:
    print("Missing dependencies. Install with:")
    print("  pip3 install requests beautifulsoup4")
    sys.exit(1)

URL = "https://murlok.io/warrior/fury/m+"
OUTPUT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "Data")
OUTPUT_FILE = os.path.join(OUTPUT_DIR, "MurlokData.lua")


def fetch_page():
    """Fetch the murlok.io page HTML."""
    headers = {
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
                       "AppleWebKit/537.36 (KHTML, like Gecko) "
                       "Chrome/131.0.0.0 Safari/537.36"
    }
    resp = requests.get(URL, headers=headers, timeout=30)
    resp.raise_for_status()
    return resp.text


def parse_stats(soup):
    """Parse secondary stat distribution."""
    stats = []
    stats_div = soup.find("div", class_="guide-stats")
    if not stats_div:
        return stats

    items = stats_div.find_all("li", class_="guide-stats-chart-item")
    for item in items:
        spans = item.find_all("span")
        if len(spans) >= 2:
            # First span: "42% Haste"
            text = spans[0].get_text(strip=True)
            match = re.match(r"(\d+)%\s+(.+)", text)
            if match:
                percent = int(match.group(1))
                name = match.group(2)
                # Second span: "+471"
                rating_text = spans[1].get_text(strip=True)
                rating_match = re.match(r"\+?(\d+)", rating_text)
                rating = int(rating_match.group(1)) if rating_match else 0
                stats.append({
                    "name": name,
                    "percent": percent,
                    "avgRating": rating,
                })
    return stats


def parse_minor_stats(soup):
    """Parse minor stats (avoidance, leech, speed)."""
    stats = []
    stats_divs = soup.find_all("div", class_="guide-stats")
    if len(stats_divs) < 2:
        return stats

    minor_div = stats_divs[1]
    items = minor_div.find_all("li", class_="guide-stats-chart-item")
    for item in items:
        spans = item.find_all("span")
        if len(spans) >= 2:
            text = spans[0].get_text(strip=True)
            match = re.match(r"(\d+)%\s+(.+)", text)
            if match:
                percent = int(match.group(1))
                name = match.group(2)
                rating_text = spans[1].get_text(strip=True)
                rating_match = re.match(r"\+?(\d+)", rating_text)
                rating = int(rating_match.group(1)) if rating_match else 0
                stats.append({
                    "name": name,
                    "percent": percent,
                    "avgRating": rating,
                })
    return stats


def parse_talents(soup):
    """Parse talent data from the talent trees."""
    class_talents = []
    spec_talents = []
    hero_talents = []

    talent_trees_view = soup.find_all("div", class_="guide-talent-trees-view")

    for tree_view in talent_trees_view:
        # Get the header to determine tree type
        header = tree_view.find("h3")
        if not header:
            continue
        header_text = header.get_text(strip=True)

        talent_cells = tree_view.find_all("li", class_="guide-talent-tree-cell")
        talents_list = []
        for cell in talent_cells:
            link = cell.find("a", class_="guide-talent")
            if not link:
                continue
            img = link.find("img")
            count_div = link.find("div", class_="guide-talent-count")
            if img and count_div:
                name = img.get("alt", "Unknown")
                try:
                    count = int(count_div.get_text(strip=True))
                except ValueError:
                    count = 0
                if count > 0:
                    talents_list.append({
                        "name": name,
                        "count": count,
                    })

        # Sort by count descending
        talents_list.sort(key=lambda x: x["count"], reverse=True)

        if "Warrior Talents" in header_text or "Class" in header_text:
            class_talents = talents_list
        elif "Fury Talents" in header_text or "Spec" in header_text:
            spec_talents = talents_list
        else:
            hero_talents = talents_list

    return class_talents, spec_talents, hero_talents


def parse_hero_talent_summary(soup):
    """Parse hero talent choice summary (Mountain Thane vs Slayer)."""
    hero_choices = []
    # Look for links to hero talent sub-pages
    hero_links = soup.find_all("a", href=re.compile(r"/warrior/fury/(mountain-thane|slayer)/m\+"))
    seen = set()
    for link in hero_links:
        href = link.get("href", "")
        match = re.search(r"/warrior/fury/(mountain-thane|slayer)/m\+", href)
        if match and match.group(1) not in seen:
            hero_name_raw = match.group(1)
            seen.add(hero_name_raw)
            name = hero_name_raw.replace("-", " ").title()
            hero_choices.append(name)

    return hero_choices


def _parse_all_item_sections(soup):
    """
    Parse all vi-box-with-header sections that contain list-items.
    Returns a list of dicts with section metadata for classification.
    """
    results = []
    all_sections = soup.find_all("div", class_="vi-box-with-header")

    for section in all_sections:
        h3 = section.find("h3")
        if not h3:
            continue
        slot_name = h3.get_text(strip=True)

        items_list = section.find_all("a", class_="list-item")
        if not items_list:
            continue

        # Classify by first item's href and img
        first_item = items_list[0]
        href = first_item.get("href", "")
        img = first_item.find("img")
        img_src = img.get("src", "") if img else ""

        is_enchant = ("enchant" in img_src.lower()
                      or href == "https://www.wowhead.com/item=0")
        is_gem = slot_name in ("Algari Diamond", "Fiber", "Prismatic",
                               "Ruby", "Sapphire", "Emerald", "Onyx",
                               "Amber", "Amethyst")

        items = []
        for item_el in items_list:
            h4 = item_el.find("h4")
            if not h4:
                continue
            item_name = h4.get_text(strip=True)
            count = 0
            media_objects = item_el.find_all("li", class_="vi-media-object")
            for mo in media_objects:
                text = mo.get_text(strip=True)
                if text.isdigit():
                    count = int(text)
            items.append({"name": item_name, "count": count})

        if not items:
            continue

        items.sort(key=lambda x: x["count"], reverse=True)

        results.append({
            "slot": slot_name,
            "items": items,
            "is_enchant": is_enchant,
            "is_gem": is_gem,
            "href": href,
        })

    return results


def parse_gear_enchants_gems(soup):
    """
    Parse gear, enchants, and gems from the page.

    The page has three groups of vi-box-with-header sections:
    1. Gear sections (first occurrence of each slot, links to real wowhead items)
    2. Enchant sections (second occurrence, links to item=0 or enchant imgs)
    3. Gem sections (headers are gem categories like "Algari Diamond")

    Returns: (gear_list, enchants_list, gems_list)
    """
    all_sections = _parse_all_item_sections(soup)

    gear = []
    enchants = []
    gems = []

    # Gear slots appear first, then enchants for same slots appear again.
    # Track which slots we've already seen as gear.
    seen_gear_slots = set()

    # The gear slots on murlok.io, in order
    gear_slot_names = {
        "Head", "Neck", "Shoulders", "Back", "Chest", "Wrist",
        "Hands", "Waist", "Legs", "Feet", "Rings", "Trinkets",
        "Main Hand", "Off Hand",
        # Alternate display names
        "Finger", "Ring", "Trinket",
    }

    for section in all_sections:
        slot = section["slot"]

        if section["is_gem"]:
            gems.append({
                "category": slot,
                "items": section["items"],
            })
        elif slot in gear_slot_names:
            if section["is_enchant"] or slot in seen_gear_slots:
                # Second occurrence of a slot = enchant/embellishment
                enchants.append({
                    "slot": slot,
                    "items": section["items"],
                })
            else:
                # First occurrence = gear
                seen_gear_slots.add(slot)
                gear.append({
                    "slot": slot,
                    "items": section["items"],
                })
        else:
            # Unknown slot name - skip
            pass

    return gear, enchants, gems


def parse_races(soup):
    """Parse race distribution from player listings."""
    race_counts = {}

    # Find all player entries - they contain race info in div text
    # Pattern: "Race | Hero Talent | ilvl"
    # Search for text matching "Race \n| Hero Talent \n| NNN ilvl"
    player_entries = soup.find_all("div", class_="h3")
    for entry in player_entries:
        parent = entry.parent
        if not parent:
            continue
        text = parent.get_text(separator="|", strip=True)
        # Look for pattern with race name and ilvl
        match = re.search(r"\|([^|]+)\|\s*(Mountain Thane|Slayer)\s*\|\s*\d+\s*ilvl", text)
        if match:
            race = match.group(1).strip()
            race_counts[race] = race_counts.get(race, 0) + 1

    # Convert to sorted list
    total = sum(race_counts.values()) or 1
    races = []
    for name, count in sorted(race_counts.items(), key=lambda x: x[1], reverse=True):
        races.append({
            "name": name,
            "count": count,
            "percent": round(count / total * 100, 1),
        })

    return races


def lua_escape(s):
    """Escape a string for Lua."""
    return s.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")


def generate_lua(data):
    """Generate Lua data file content."""
    lines = []
    lines.append("-- MurlokFury Data File")
    lines.append("-- Auto-generated by fetch_murlok.py")
    lines.append(f'-- Source: {data["meta"]["source"]}')
    lines.append(f'-- Generated: {data["meta"]["updated"]}')
    lines.append("-- DO NOT EDIT MANUALLY")
    lines.append("")
    lines.append("MURLOK_DATA = {")

    # Meta
    lines.append("    meta = {")
    lines.append(f'        source = "{lua_escape(data["meta"]["source"])}",')
    lines.append(f'        updated = "{lua_escape(data["meta"]["updated"])}",')
    lines.append(f'        sampleSize = {data["meta"]["sampleSize"]},')
    lines.append(f'        class = "{lua_escape(data["meta"]["class"])}",')
    lines.append(f'        spec = "{lua_escape(data["meta"]["spec"])}",')
    lines.append(f'        content = "{lua_escape(data["meta"]["content"])}",')
    lines.append("    },")

    # Hero Talents
    lines.append("")
    lines.append("    heroTalents = {")
    for t in data.get("heroTalents", []):
        lines.append(f'        {{ name = "{lua_escape(t["name"])}", count = {t["count"]}, percent = {t["percent"]} }},')
    lines.append("    },")

    # Class Talents
    lines.append("")
    lines.append("    classTalents = {")
    for t in data.get("classTalents", []):
        lines.append(f'        {{ name = "{lua_escape(t["name"])}", count = {t["count"]} }},')
    lines.append("    },")

    # Spec Talents
    lines.append("")
    lines.append("    specTalents = {")
    for t in data.get("specTalents", []):
        lines.append(f'        {{ name = "{lua_escape(t["name"])}", count = {t["count"]} }},')
    lines.append("    },")

    # Stats
    lines.append("")
    lines.append("    stats = {")
    for s in data.get("stats", []):
        lines.append(f'        {{ name = "{lua_escape(s["name"])}", percent = {s["percent"]}, avgRating = {s["avgRating"]} }},')
    lines.append("    },")

    # Minor Stats
    lines.append("")
    lines.append("    minorStats = {")
    for s in data.get("minorStats", []):
        lines.append(f'        {{ name = "{lua_escape(s["name"])}", percent = {s["percent"]}, avgRating = {s["avgRating"]} }},')
    lines.append("    },")

    # Gear
    lines.append("")
    lines.append("    gear = {")
    for g in data.get("gear", []):
        lines.append(f'        {{')
        lines.append(f'            slot = "{lua_escape(g["slot"])}",')
        lines.append(f'            items = {{')
        for item in g["items"]:
            lines.append(f'                {{ name = "{lua_escape(item["name"])}", count = {item["count"]} }},')
        lines.append(f'            }},')
        lines.append(f'        }},')
    lines.append("    },")

    # Enchants
    lines.append("")
    lines.append("    enchants = {")
    for e in data.get("enchants", []):
        lines.append(f'        {{')
        lines.append(f'            slot = "{lua_escape(e["slot"])}",')
        lines.append(f'            items = {{')
        for item in e["items"]:
            lines.append(f'                {{ name = "{lua_escape(item["name"])}", count = {item["count"]} }},')
        lines.append(f'            }},')
        lines.append(f'        }},')
    lines.append("    },")

    # Gems
    lines.append("")
    lines.append("    gems = {")
    for g in data.get("gems", []):
        lines.append(f'        {{')
        lines.append(f'            category = "{lua_escape(g["category"])}",')
        lines.append(f'            items = {{')
        for item in g["items"]:
            lines.append(f'                {{ name = "{lua_escape(item["name"])}", count = {item["count"]} }},')
        lines.append(f'            }},')
        lines.append(f'        }},')
    lines.append("    },")

    # Races
    lines.append("")
    lines.append("    races = {")
    for r in data.get("races", []):
        lines.append(f'        {{ name = "{lua_escape(r["name"])}", count = {r["count"]}, percent = {r["percent"]} }},')
    lines.append("    },")

    lines.append("}")
    lines.append("")

    return "\n".join(lines)


def main():
    print(f"Fetching data from {URL}...")
    html = fetch_page()
    print(f"  Page size: {len(html)} bytes")

    soup = BeautifulSoup(html, "html.parser")

    # Parse all data sections
    print("Parsing stats...")
    stats = parse_stats(soup)
    minor_stats = parse_minor_stats(soup)
    print(f"  Found {len(stats)} secondary stats, {len(minor_stats)} minor stats")

    print("Parsing talents...")
    class_talents, spec_talents, hero_talents = parse_talents(soup)
    hero_choices = parse_hero_talent_summary(soup)
    print(f"  Found {len(class_talents)} class talents, {len(spec_talents)} spec talents, {len(hero_talents)} hero talents")
    print(f"  Hero talent choices: {hero_choices}")

    # Build hero talent summary from talent counts if available
    hero_summary = []
    if hero_talents:
        # Hero talents are individual talent nodes, not the choice summary
        # We need to derive Mountain Thane vs Slayer from the data
        pass

    # Calculate hero talent choice from player race data and talent links
    # The page shows Mountain Thane (47 players) and Slayer (3 players)
    # We can derive this from the hero talent tree counts
    mt_count = 0
    sl_count = 0
    for t in hero_talents:
        if t["count"] > mt_count:
            mt_count = t["count"]

    # Get hero counts from the overall data
    # Mountain Thane talents all show count=47, Slayer shows count=3
    # Use the maximum count from each hero tree
    # Since we parse one combined hero tree, look at the page for explicit counts
    # Better approach: count races per hero talent from player list
    hero_summary = []
    if hero_choices:
        # We know from the page: Mountain Thane (47), Slayer (3)
        # Parse from actual talent nodes
        mt_max = 0
        sl_max = 0
        for t in hero_talents:
            if t["count"] > 25:  # Most likely Mountain Thane
                mt_max = max(mt_max, t["count"])
            else:
                sl_max = max(sl_max, t["count"])

        total_heroes = mt_max + sl_max if (mt_max + sl_max) > 0 else 50
        if mt_max > 0:
            hero_summary.append({
                "name": "Mountain Thane",
                "count": mt_max,
                "percent": round(mt_max / total_heroes * 100, 1),
            })
        if sl_max > 0:
            hero_summary.append({
                "name": "Slayer",
                "count": sl_max,
                "percent": round(sl_max / total_heroes * 100, 1),
            })
        # If we only found one, add the other
        if len(hero_summary) == 1:
            other_name = "Slayer" if hero_summary[0]["name"] == "Mountain Thane" else "Mountain Thane"
            other_count = total_heroes - hero_summary[0]["count"]
            if other_count > 0:
                hero_summary.append({
                    "name": other_name,
                    "count": other_count,
                    "percent": round(other_count / total_heroes * 100, 1),
                })

    print("Parsing gear, enchants, and gems...")
    gear, enchants, gems = parse_gear_enchants_gems(soup)
    print(f"  Found {len(gear)} gear slots, {len(enchants)} enchant slots, {len(gems)} gem categories")
    for g in gear:
        print(f"    Gear - {g['slot']}: {len(g['items'])} items")
    for e in enchants:
        print(f"    Enchant - {e['slot']}: {len(e['items'])} items")
    for g in gems:
        print(f"    Gem - {g['category']}: {len(g['items'])} items")

    print("Parsing races...")
    races = parse_races(soup)
    print(f"  Found {len(races)} races")

    # Determine sample size from data
    sample_size = 50  # Default
    if stats:
        # Use max count from any talent as sample size
        all_counts = [t["count"] for t in class_talents + spec_talents]
        if all_counts:
            sample_size = max(all_counts)

    # Calculate percentages for talents
    for t in class_talents:
        t["percent"] = round(t["count"] / sample_size * 100, 1) if sample_size > 0 else 0
    for t in spec_talents:
        t["percent"] = round(t["count"] / sample_size * 100, 1) if sample_size > 0 else 0

    # Sort stats by rating descending (priority order)
    stats.sort(key=lambda x: x["avgRating"], reverse=True)

    # Assemble final data
    now = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    data = {
        "meta": {
            "source": URL,
            "updated": now,
            "sampleSize": sample_size,
            "class": "Warrior",
            "spec": "Fury",
            "content": "M+",
        },
        "heroTalents": hero_summary,
        "classTalents": class_talents,
        "specTalents": spec_talents,
        "stats": stats,
        "minorStats": minor_stats,
        "gear": gear,
        "enchants": enchants,
        "gems": gems,
        "races": races,
    }

    # Generate Lua
    lua_content = generate_lua(data)

    # Write output
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        f.write(lua_content)

    print(f"\nOutput written to: {OUTPUT_FILE}")
    print(f"File size: {len(lua_content)} bytes")

    # Summary
    print("\n=== Data Summary ===")
    print(f"Sample size: {sample_size}")
    print(f"Hero talents: {len(hero_summary)}")
    print(f"Class talents: {len(class_talents)}")
    print(f"Spec talents: {len(spec_talents)}")
    print(f"Stats: {len(stats)}")
    print(f"Gear slots: {len(gear)}")
    print(f"Enchant slots: {len(enchants)}")
    print(f"Gem categories: {len(gems)}")
    print(f"Races: {len(races)}")


if __name__ == "__main__":
    main()
