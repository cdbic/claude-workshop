---
name: code-review
description: Review the current diff for correctness bugs and obvious simplification opportunities.
---

# code-review

Read the current git diff. Report, one line per finding:
- Correctness bugs: concrete input that produces a wrong result or crash.
- Simplification: code that reinvents something the stdlib or an existing helper in this repo already does.

Skip style nitpicks. If nothing's wrong, say so in one line — don't invent findings to fill space.
