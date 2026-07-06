"""Count Claude tokens for a file or a literal string.

Needs: pip install anthropic, and an ANTHROPIC_API_KEY env var
(free Console account; the token-counting endpoint itself is free).

Usage:
    python3 workshop/count_tokens.py README.md
    python3 workshop/count_tokens.py "the cat sat on the mat"
"""
import sys
from pathlib import Path

import anthropic

arg = sys.argv[1] if len(sys.argv) > 1 else "README.md"
text = Path(arg).read_text() if Path(arg).exists() else arg
resp = anthropic.Anthropic().messages.count_tokens(
    model="claude-sonnet-5",
    messages=[{"role": "user", "content": text}],
)
label = arg if Path(arg).exists() else f'"{arg}"'
print(f"{label}: {resp.input_tokens} tokens")
