#!/usr/bin/env python3
"""RTK guardrail — block bare commands without rtk prefix.

PreToolUse hook (Bash matcher). Exit 2 = block + show message to model.
Simplified for the workshop demo; the full version also syncs its blocked
set with custom .rtk/filters.toml entries.
"""
import json
import re
import shutil
import sys

if not shutil.which("rtk"):
    sys.exit(0)  # rtk not installed (e.g. workshop attendee clone) — no-op

data = json.load(sys.stdin)
cmd_str = data.get("tool_input", {}).get("command", "").strip()

# Find the first non-env-var token in the command
first = ""
for tok in cmd_str.split():
    if not re.match(r"^[A-Z_][A-Z0-9_]*=", tok):
        first = tok
        break

if not first:
    sys.exit(0)

blocked = {"git", "grep", "ls", "find", "tail", "wc"}

if first in blocked:
    print(
        f'RTK guardrail: bare "{first}" blocked — rewrite as: rtk {first} ...',
        file=sys.stderr,
    )
    sys.exit(2)

# Block destructive git operations (bare and rtk-prefixed)
destructive_patterns = [
    (r"\b(rtk\s+)?git\s+push\b.*--force", "no force push — open a PR"),
    (r"\b(rtk\s+)?git\s+reset\s+--hard", "destructive reset — confirm manually before running"),
    (r"\b(rtk\s+)?git\s+push\b[^|&;]*\bmain\b", "never push directly to main — open a PR"),
]
for pattern, msg in destructive_patterns:
    if re.search(pattern, cmd_str):
        print(f"RTK guardrail: {msg}", file=sys.stderr)
        sys.exit(2)

# Block plaintext secrets in commands
# Allow: shell vars ($VAR), placeholders (<foo>), op:// refs, subshell/command refs ($( ` ')
secret_pattern = re.compile(
    r'\b(TOKEN|DSN|PASSWORD|SECRET_KEY|SECRET_ACCESS_KEY|CREDENTIALS)\s*=\s*(?![<$(`\'"]|op://)',
    re.IGNORECASE,
)
if secret_pattern.search(cmd_str):
    print(
        "RTK guardrail: looks like a plaintext secret — use a secret manager or shell variable instead",
        file=sys.stderr,
    )
    sys.exit(2)
