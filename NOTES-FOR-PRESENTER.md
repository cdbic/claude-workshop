# Presenter notes — how this repo maps to the agenda

This repo is the one asset shared by all three demo-only afternoon blocks.

All day-of materials live in `workshop/`: `slides.md` (Marp deck), `lab1-handout.md` + `lab2-handout.md` + `data/coffee_sales.csv` (attendee labs), `cheatsheet.md` (wrap-up), `prework-email.md`, `cohost-onepager.md`. Note: `workshop/` will be visible on screen during the CLI demo — either mention it's the workshop's own material, or `mv` it out beforehand.

## 14:35 Claude Code CLI walkthrough
- Open with `/grill-me` on the feature idea ("add search to the notes CLI") — let it ask 2-3 questions, answer live, show the SPEC/VERIFIER/ENVIRONMENT brief it produces. This is the segue from "prompting" to "working with an agent".
- Live-build target: add a `search <term>` subcommand to `notes_cli/cli.py` + `storage.py` (not built yet — build it live, against the brief grill-me just produced).
- Shows: session/token visibility, prompt → tool calls → verify loop.
- Somewhere mid-build, type a bare `git status` on purpose — the RTK guardrail hook blocks it live. One-liner: hooks are guardrails the harness enforces. Then `rtk git status` passes, and `rtk gain` shows the cumulative savings number.

## 15:40 Skills, schedules & the "AI brain"
- Skills showcase, in this order:
  1. `/changelog` or `/code-review` — 30-second warm-up: a skill is just a markdown file, open its `SKILL.md` on screen.
  2. `/grill-me` — callback: "you already saw this one an hour ago" — open its SKILL.md, show how little text produces that behavior.
  3. `/compound` — the finale: run it on the search-feature session you just built; it writes a real wiki page into `.claude/wiki/` and updates INDEX.md live. This is the compounding-knowledge punchline of the whole "AI brain" story.
- `.claude/schedules/weekly-digest.md` — illustrative only, talk through it, don't actually register it.
- `CLAUDE.md` / `AGENTS.md` / `.claude/wiki/` — walk through the three-tier knowledge architecture using this repo as the concrete example; the page compound just wrote is now part of it.
- RTK wrap: `.rtk/filters.toml` on screen — custom output filters as the extension mechanism; note the repo's hook is a simplified copy (the full version auto-syncs its blocked set with filters.toml).
- Closing beat: open `workshop/ai-brain-setup.sh` — the real bootstrap script. Punchline: the entire AI brain is one idempotent shell script; skills are just heredoc'd markdown. Scroll it, don't run it (the header explains why — it writes to the global `~/.claude/skills/` and prunes flat .md files there).

## 16:25 Claude Cowork
- Just open this folder in Cowork — no extra setup needed beyond what's already here.

## Pre-work reminder
- Run the presenter setup in `README.md` → Prerequisites (`brew bundle`, Claude Code install, `rtk trust`, render slides).
- Confirm your own Pro/Max or Console access to Claude Code + Cowork is active before the day.
