# LLM Agent Instructions

## Behavioural rules

**Goal-driven execution**

Turn tasks into verifiable goals before starting:
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Add a feature" → "Write tests for the new behavior, then make them pass"

For multi-step tasks, state a brief plan with an explicit verify step per stage.

## Subagent model selection

Match subagent model to task weight — cheap/fast models for read-only lookups, stronger models for implementation and design work.

## Knowledge architecture (demo)

This repo pairs with:
- Auto-memory (outside the repo, per-project) — collaboration facts and preferences.
- `.claude/wiki/` (this repo) — codebase-specific architecture and decisions, see `.claude/wiki/INDEX.md`.
- A global knowledge hub (outside the repo) — general patterns and tools, shared across projects.
