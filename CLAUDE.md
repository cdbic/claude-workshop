# CLAUDE.md

Guidance for Claude Code when working in this repo.

## What this is

`notes-cli` — a tiny local notes CLI, stdlib-only Python. Built as a live demo project: everything here is disposable, there's no production system behind it.

## Architecture

- `notes_cli/cli.py` — argparse entrypoint: `add`, `list`, `done` subcommands.
- `notes_cli/storage.py` — JSON-file persistence (`notes.json` in the cwd). No database, no framework — deliberately minimal.
- `tests/test_cli.py` — one smoke test covering the add → list → complete round trip.

## Commands

```bash
python -m notes_cli.cli add "buy coffee"
python -m notes_cli.cli list
python -m notes_cli.cli done 1
python -m unittest tests.test_cli
```

## Conventions

@AGENTS.md

- Keep it stdlib-only. No dependencies unless a live demo specifically calls for adding one.
- This repo is reused across three workshop segments — see `NOTES-FOR-PRESENTER.md` for what each one needs.
