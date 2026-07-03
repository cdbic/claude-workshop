# Presenter notes — how this repo maps to the agenda

This repo is the one asset shared by all three demo-only afternoon blocks.

All day-of materials live in `workshop/`: `slides.md` (Marp deck), `lab1-handout.md` + `lab2-handout.md` + `data/coffee_sales.csv` (attendee labs), `cheatsheet.md` (wrap-up), `prework-email.md`, `cohost-onepager.md`. Note: `workshop/` will be visible on screen during the CLI demo — either mention it's the workshop's own material, or `mv` it out beforehand.

## 14:35 Claude Code CLI walkthrough
- Live-build target: add a `search <term>` subcommand to `notes_cli/cli.py` + `storage.py` (not built yet — build it live).
- Shows: session/token visibility, prompt → tool calls → verify loop.

## 15:40 Skills, schedules & the "AI brain"
- `.claude/skills/changelog/SKILL.md` and `.claude/skills/code-review/SKILL.md` — run one live against the diff from the CLI walkthrough.
- `.claude/schedules/weekly-digest.md` — illustrative only, talk through it, don't actually register it.
- `CLAUDE.md` / `AGENTS.md` / `.claude/wiki/` — walk through the three-tier knowledge architecture using this repo as the concrete example.

## 16:25 Claude Cowork
- Just open this folder in Cowork — no extra setup needed beyond what's already here.

## Pre-work reminder
- Confirm your own Pro/Max or Console access to Claude Code + Cowork is active before the day.
