# Example schedule: weekly-digest

Illustrative only — not wired up to any real cron/EventBridge trigger. This is what a "schedule" would look like if this were a real project:

- **Cadence**: every Monday 09:00
- **Prompt**: "Summarize notes added and completed in notes.json over the last 7 days into a short digest."
- **Why**: shows how a recurring agent run can turn a manual habit (skimming your notes file) into something that shows up in your inbox on its own.

In a real Claude Code setup this would be created with the `schedule` skill / cron tooling, not hand-written here.
