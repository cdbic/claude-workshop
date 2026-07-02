# Architecture

`notes_cli` is intentionally tiny:

- **Storage**: a single JSON file (`notes.json`) in the working directory. No database — there's exactly one user and no concurrency to worry about.
- **CLI**: `argparse` with three subcommands (`add`, `list`, `done`). No plugin system, no config file — there's nothing to configure yet.

## Why this shape

This is a workshop demo project, not a real product — the point is to have something small enough to live-build a feature in front of an audience, not to showcase production architecture.
