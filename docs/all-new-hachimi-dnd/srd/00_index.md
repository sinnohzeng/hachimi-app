# System Reference Document 5.2.1 — Markdown Edition

> **License:** This work includes material from the System Reference Document 5.2.1 ("SRD 5.2.1") by Wizards of the Coast LLC, available at <https://www.dndbeyond.com/srd>. The SRD 5.2.1 is licensed under the **Creative Commons Attribution 4.0 International License** ([CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/legalcode)).

## Overview

The SRD 5.2.1 is the free, open-licensed core ruleset for Dungeons & Dragons 5th Edition (2024 revision). This Markdown edition was converted from the official 364-page PDF for LLM-friendly consumption.

## Document Structure

| # | File | Pages | Content |
|---|------|-------|---------|
| 00 | [00_index.md](00_index.md) | — | This index, license, and usage guide |
| 01 | [01_playing_the_game.md](01_playing_the_game.md) | 5–18 | Core mechanics: abilities, D20 tests, combat, damage/healing |
| 02 | [02_character_creation.md](02_character_creation.md) | 19–27 | Character creation steps, multiclassing, trinkets |
| 03 | [03_classes.md](03_classes.md) | 28–81 | All 12 classes with subclasses and spell lists |
| 04 | [04_character_origins.md](04_character_origins.md) | 82–85 | Backgrounds (4) and species (9) |
| 05 | [05_feats.md](05_feats.md) | 86–87 | Origin feats, general feats, fighting styles, epic boons |
| 06 | [06_equipment.md](06_equipment.md) | 88–102 | Weapons, armor, tools, adventuring gear, mounts |
| 07 | [07_spells.md](07_spells.md) | 103–175 | Spellcasting rules and all spell descriptions |
| 08 | [08_rules_glossary.md](08_rules_glossary.md) | 176–191 | Alphabetical rules reference (conditions, actions, etc.) |
| 09 | [09_gameplay_toolbox.md](09_gameplay_toolbox.md) | 192–203 | DM tools: travel, traps, hazards, encounter building |
| 10 | [10_magic_items.md](10_magic_items.md) | 204–253 | Magic item rules and A–Z catalog |
| 11 | [11_monsters.md](11_monsters.md) | 254–257 | Monster stat block format and running monsters |
| 12 | [12_monsters_a_z.md](12_monsters_a_z.md) | 258–343 | Monster stat blocks A–Z |
| 13 | [13_animals.md](13_animals.md) | 344–364 | Animal and beast stat blocks |

## Key Statistics

- **Total pages:** 364
- **Total characters:** ~1.5M (Markdown)
- **Chapter files:** 13 + index
- **TOC entries:** 520 (1 L1, 13 L2, 342 L3, 164 L4)
- **Classes:** 12 (Barbarian, Bard, Cleric, Druid, Fighter, Monk, Paladin, Ranger, Rogue, Sorcerer, Warlock, Wizard)
- **Species:** 9 (Dragonborn, Dwarf, Elf, Gnome, Goliath, Halfling, Human, Orc, Tiefling)
- **Backgrounds:** 4 (Acolyte, Criminal, Sage, Soldier)

## Chapter Summaries

### Playing the Game (01)
Core game mechanics including the six ability scores, D20 tests (ability checks, saving throws, attack rolls), advantage/disadvantage, proficiency, actions, social interaction, exploration, and complete combat rules with damage types, healing, and death saves.

### Character Creation (02)
Step-by-step character creation (class, origin, ability scores, alignment, details), level advancement tables, starting at higher levels, multiclassing prerequisites and rules, and the trinkets table.

### Classes (03)
Complete rules for all 12 classes: class features by level, subclass options (one per class), and spell lists for spellcasting classes. Each class includes hit dice, proficiencies, starting equipment, and multi-level feature progression.

### Character Origins (04)
Four backgrounds (Acolyte, Criminal, Sage, Soldier) each providing ability score increases, an origin feat, skill proficiencies, and tool proficiency. Nine playable species with racial traits.

### Feats (05)
Four categories: Origin Feats (available at level 1 via backgrounds), General Feats, Fighting Style Feats, and Epic Boon Feats (level 19+).

### Equipment (06)
Comprehensive equipment catalog: weapons with properties and mastery options, armor categories, tools, adventuring gear with costs and weights, mounts and vehicles, lifestyle expenses, and crafting rules.

### Spells (07)
Spellcasting fundamentals (spell slots, components, concentration, ritual casting) followed by the complete alphabetical spell descriptions — the largest chapter by far.

### Rules Glossary (08)
Alphabetical reference of game terms, conditions (Blinded, Charmed, etc.), actions, and mechanical definitions used throughout the SRD.

### Gameplay Toolbox (09)
DM-facing tools: travel pace, creating custom backgrounds, curses and magical contagions, environmental effects, fear/mental stress, poisons, trap design, and combat encounter building.

### Magic Items (10)
Magic item categories, rarity tiers, activation rules, cursed items, sentient items, crafting rules, and the complete A–Z catalog of magic items with descriptions.

### Monsters (11)
How to read and use monster stat blocks, including ability scores, challenge rating, actions, reactions, legendary actions, and lair actions.

### Monsters A–Z (12)
The complete bestiary of monsters from Aboleth to Zombie, with full stat blocks including AC, HP, abilities, attacks, and special features.

### Animals (13)
Stat blocks for mundane and giant animals — beasts commonly used as mounts, familiars, wild shape forms, and conjured creatures.

## LLM Usage Guide

### Loading Strategy
- **Full context:** Load all 13 chapter files (~1.5M chars / ~375K tokens) for comprehensive rules access
- **Selective loading:** Load only the chapters relevant to your task:
  - Character building → 01 + 02 + 03 + 04 + 05
  - Combat rules → 01 + 08
  - Spellcasting → 07
  - DM encounter prep → 09 + 11 + 12 + 13
  - Magic items → 10
  - Equipment → 06

### Referencing
Each chapter maintains the original heading hierarchy (H2–H4) for precise navigation. Use heading text for cross-references between chapters.

## Conversion Notes

- **Source:** `SRD_CC_v5.2.1.pdf` (5.8 MB, 364 pages)
- **Tool:** pymupdf4llm 1.27.2.1 with TOC-based heading correction
- **Heading coverage:** 519/520 TOC entries matched (99.8%)
- **Known limitations:**
  - Some tables are rendered as pipe-delimited Markdown; complex multi-column tables may have formatting artifacts
  - Images/illustrations are referenced as placeholders, not embedded
  - A few heading levels within body text may not perfectly match the PDF's visual hierarchy for non-TOC headings
