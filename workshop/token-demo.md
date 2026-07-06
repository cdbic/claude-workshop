# Token & context live demo (Claude 101, ~10:00)

Live demo for the "Tokens: the unit of everything" slide. Uses Claude Code's own status line — no separate API key, no extra platform credits, just data Claude Code already tracks for the session.

## What it shows

`.claude/statusline.ps1` reads the JSON Claude Code feeds every status line update and prints:

- Context window usage — a 10-block bar and `%`
- Session cost so far (USD)
- Rate limit remaining — 5-hour session window and 7-day weekly window (Pro/Max only, appears after the first response)
- Cumulative tokens burned this session (summed from the transcript file, since the status line JSON only exposes the *last* API call's usage)

## Install (already wired for this repo)

`.claude/settings.json` already points `statusLine` at the script:

```json
"statusLine": {
  "type": "command",
  "command": "pwsh -NoProfile -File \"$CLAUDE_PROJECT_DIR/.claude/statusline.ps1\""
}
```

Requirements:
- **PowerShell 7 (`pwsh`) on PATH.** Not the legacy `powershell.exe` — on this machine (and likely others with a hardened default), Windows PowerShell 5.1 is locked to the `AllSigned` execution policy and refuses to run an unsigned local script. `pwsh` defaults to `RemoteSigned`, which allows it. Install from https://github.com/PowerShell/PowerShell/releases or `winget install Microsoft.PowerShell` if `pwsh` isn't already on PATH.
- Nothing else — the script only reads stdin JSON and the transcript file Claude Code already writes.

Cloning this repo and opening it with Claude Code is enough; the status line appears automatically once you accept the workspace trust prompt.

## On-stage beat

1. Open `claude` in this repo (status line visible at the bottom).
2. Send a couple of prompts — point at the context `%` and cost ticking up live.
3. Paste a large file (e.g. `README.md`) into a prompt and show the context bar jump — ties directly to "when the window fills up: older content is dropped or summarized."

## Fallback — claude.ai (zero install)

If nothing is installed, open claude.ai and talk through the concepts (tokens, context window, billing) without live numbers.

## Presenter checklist

- [ ] `pwsh` installed and on PATH before the session
- [ ] `claude` already running in this repo, status line visible, before going on stage
- [ ] Send one throwaway message beforehand — rate limit fields only appear after the first API response
- [ ] A large file ready to paste (e.g. `README.md`) to show the context jump
