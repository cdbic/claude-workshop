# notes-cli

A tiny, stdlib-only Python notes CLI. Built as a throwaway demo project for a Claude workshop — see `NOTES-FOR-PRESENTER.md` for how it's used. Workshop materials (slides, lab handouts, cheat sheet) live in `workshop/`.

## Prerequisites

**Workshop attendee** — nothing to install. A laptop, a browser, and a free account at https://claude.ai (see `workshop/prework-email.md`).

**Running the CLI / cloning this repo** — Python 3.8+ only (stdlib, no pip installs).

**Presenter / full demo setup — macOS/Linux:**

```bash
brew bundle                                   # marp-cli + rtk (see Brewfile)
npm install -g @anthropic-ai/claude-code      # Claude Code CLI (needs Pro/Max or an API key)
rtk trust                                     # one-time: enable this repo's .rtk/filters.toml
marp workshop/slides.md -o slides.html        # render the deck (press `p` in browser for presenter view)
```

**Presenter / full demo setup — Windows:**

```powershell
.\setup.ps1        # marp-cli + Claude Code via npm; prints rtk install pointer
rtk trust          # after installing rtk from https://github.com/rtk-ai/rtk/releases
marp workshop/slides.md -o slides.html
```

Also needed for the demos: a Claude **Pro/Max** subscription (Claude Code + Cowork are not on the free tier) and the Claude desktop app for the Cowork segment.

## OS support

Everything is OS-agnostic in practice: the CLI and tests are stdlib Python (macOS/Linux/Windows), slides render anywhere marp-cli runs (npm), Claude Code and the Claude desktop app (Cowork) ship for Mac and Windows, and rtk has macOS/Linux packages plus Windows binaries. The guardrail hook resolves `python3` or `python` (whichever exists) and no-ops entirely when rtk is absent; on Windows, Claude Code runs Bash-tool commands through Git Bash, which is also where the hook executes.

Notes:
- The RTK guardrail hook (`.claude/settings.json` → `.claude/hooks/rtk-guardrail.py`) silently no-ops if `rtk` isn't installed — cloning without rtk changes nothing.
- Without `rtk trust`, rtk still works but ignores this repo's custom `.rtk/filters.toml`.

## AI brain bootstrap (showcase)

`workshop/ai-brain-setup.sh` is the presenter's real machine-bootstrap script for the "AI brain" setup shown in the afternoon segment: one idempotent shell script that writes eight skills (as heredoc'd markdown) into `~/.claude/skills/` and lays out the knowledge-hub directories. It is included to **read, not run** — it targets the global Claude config and its cleanup step deletes flat `*.md` files in `~/.claude/skills/`; the header comment has the details. Adapt the paths before using it for your own setup.

## Usage

```bash
python -m notes_cli.cli add "buy coffee"
python -m notes_cli.cli list
python -m notes_cli.cli done 1
```

## Tests

```bash
python -m unittest tests.test_cli
```
