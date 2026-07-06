# Token-counter demo (Claude 101, ~10:00)

Live demo for the "Tokens: the unit of everything" slide. Three ways to run it, most portable first. Options A and B need an API key from https://platform.claude.com (free account — the token-counting endpoint itself costs nothing).

## Option A — Python script (any OS, recommended)

```bash
pip install anthropic
export ANTHROPIC_API_KEY=sk-ant-...        # PowerShell: $env:ANTHROPIC_API_KEY="sk-ant-..."

python3 workshop/count_tokens.py README.md
python3 workshop/count_tokens.py "the cat sat on the mat"
python3 workshop/count_tokens.py "for i in range(10): print(i)"
python3 workshop/count_tokens.py "🐱🐱🐱🐱🐱🐱"
```

The three-string comparison is the on-stage beat: plain English tokenizes cheapest, code costs more, emoji cost the most — same character count, wildly different token counts.

## Option B — Anthropic CLI (macOS / Linux)

```bash
brew install --cask anthropics/tap/ant     # already in this repo's Brewfile (it's a cask)
ant auth login                             # or export ANTHROPIC_API_KEY
ant messages count-tokens --model claude-sonnet-5 \
  --message '{role: user, content: "@./README.md"}' \
  --transform input_tokens -r
```

No native Windows package — on Windows use WSL, `go install github.com/anthropics/anthropic-cli/cmd/ant@latest`, or just Option A.

## Option C — zero install (any OS, browser)

The Console Workbench at https://platform.claude.com shows input/output token usage for every run — paste the same three strings and compare. Less terminal-flavored, but works when nothing is installed.

## Presenter checklist

- [ ] API key exported in the demo terminal *before* the session (don't type a key on screen)
- [ ] `pip install anthropic` done during dry-run, not live
- [ ] The three comparison strings ready to paste
