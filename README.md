# notes-cli

A tiny, stdlib-only Python notes CLI. Built as a throwaway demo project for a Claude workshop — see `NOTES-FOR-PRESENTER.md` for how it's used.

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
