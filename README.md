# notes-cli

A tiny, stdlib-only Python notes CLI. Built as a throwaway demo project for a Claude workshop — see `NOTES-FOR-PRESENTER.md` for how it's used. Workshop materials (slides, lab handouts, cheat sheet) live in `workshop/`.

## Prerequisites

**Workshop attendee** — nothing to install. A laptop, a browser, and a free account at https://claude.ai (see `workshop/prework-email.md`).

**Running the CLI / cloning this repo** — Python 3.8+ only (stdlib, no pip installs).

**Presenter / full demo setup:**

```bash
brew bundle                                   # marp-cli + rtk (see Brewfile)
npm install -g @anthropic-ai/claude-code      # Claude Code CLI (needs Pro/Max or an API key)
rtk trust                                     # one-time: enable this repo's .rtk/filters.toml
marp workshop/slides.md -o slides.html        # render the deck (press `p` in browser for presenter view)
```

Also needed for the demos: a Claude **Pro/Max** subscription (Claude Code + Cowork are not on the free tier) and the Claude desktop app for the Cowork segment.

Notes:
- The RTK guardrail hook (`.claude/settings.json` → `.claude/hooks/rtk-guardrail.py`) silently no-ops if `rtk` isn't installed — cloning without rtk changes nothing.
- Without `rtk trust`, rtk still works but ignores this repo's custom `.rtk/filters.toml`.

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
