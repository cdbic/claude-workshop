---
name: compound
description: >
  Capture a solved problem into the project wiki, or audit the wiki for gaps
  and health issues. Modes: default (single-pass capture), --deep (parallel
  tiered agents, faster), --audit (full wiki health check).
---

# /compound — Project wiki capture & audit

> Adapted from [`everyinc/compound-engineering-plugin`](https://github.com/everyinc/compound-engineering-plugin) (`/ce-compound`).
> Writes to `.claude/wiki/` instead of `docs/solutions/`, uses per-repo
> categories, adds `--deep` tiered-agent mode and inline fast audit.

## Mode routing

| Invocation | Mode |
|---|---|
| `/compound` | Default: single-pass capture + fast audit |
| `/compound --deep` | Deep: parallel agents (faster, same fidelity) + fast audit |
| `/compound --audit` | Full audit only — no session capture |
| Unknown/combined flags | Default mode; note the unrecognized flag |

**Fast audit** runs after every capture — scoped to the touched files only (cheap).
**Full audit** (`--audit`) reads the entire wiki and runs all 6 checks.

---

## DEFAULT MODE — Single-pass session capture

Run steps 0–8 in order.

### Step 0 — Bail-out gate

If the session produced nothing durable or reusable (typo fix, one-line question answered,
no code changed, no decision made), report "nothing worth capturing" and stop.
Only proceed if the session has a root cause, a decision, or a non-obvious fix.

### Step 1 — Bootstrap check

If `.claude/wiki/INDEX.md` does not exist, create it with a Pages table and a
**Gaps / To document** section before proceeding.

### Step 2 — Classify the work

**Determine categories dynamically:**

1. If `.claude/wiki/CATEGORIES.md` exists in the current repo, read it and use
   the category slugs defined there. Each `- \`slug\`` line is one valid category.

2. If CATEGORIES.md does not exist but `.claude/wiki/` has subdirectories,
   treat each subdirectory name as a valid category slug.

3. If neither exists (wiki not yet bootstrapped), use these generic fallbacks:
   - `bug-fixes` — errors, crashes, unexpected behaviour
   - `decisions` — architectural and design choices
   - `patterns` — reusable approaches and conventions
   - `gotchas` — non-obvious traps and edge cases
   - `developer-experience` — local dev workflow, tooling, debugging

Once you have the category list, determine the **track** (bug vs knowledge) and
the single best **category** from the list. If no category fits well, use the closest
one — do not invent new slugs unless you also create the subdirectory.

### Step 3 — Extract content from the conversation

- **Problem**: What was the symptom or question?
- **Root cause**: Why did it happen, or what was the knowledge gap?
- **Fix / answer**: What change was made or decision reached?
- **Prevention**: What to watch for next time?
- **Related files**: Which repo files are directly relevant?
- **Tags**: 3–6 keywords (e.g. `cli`, `storage`, `argparse`, `tests`)
- **Severity** (bug track only): `low` / `medium` / `high`

### Step 4 — Choose filename and decide create vs. update

Format: `.claude/wiki/<category>/<slug>.md`

Slug: lowercase, hyphens, descriptive. Examples:
- `.claude/wiki/bug-fixes/notes-json-lost-on-concurrent-write.md`
- `.claude/wiki/gotchas/argparse-subcommand-exit-codes.md`
- `.claude/wiki/decisions/json-file-over-sqlite.md`

**Create vs. update**: Read the Pages table in INDEX.md. If an existing page shares
≥2 tags OR has a title/slug with ≥2 overlapping words, update it instead of creating a new one.
- **Creating**: make the category subdirectory if absent; write a new file; add an INDEX row.
- **Updating**: append or merge content into the existing file; refresh `date:`; do NOT add a
  new INDEX row (the existing one stays).

### Step 5 — Write or update the wiki page

```markdown
---
date: YYYY-MM-DD
tags: [tag1, tag2, tag3]
severity: medium          # bug track only — omit for knowledge track
related_files:
  - notes_cli/storage.py
  - tests/test_cli.py
---

# <Title>

## Problem
<Symptom or question>

## Root cause
<Why it happened / what was unknown>

## Fix
<What was changed or decided>

## Prevention
<How to avoid recurrence / what to check next time>

## See also
- [Related page](../category/page.md)   ← only if one exists
```

### Step 6 — Update INDEX.md (create path only)

When creating a new page, add a row to the Pages table:
```
| [Title](category/slug.md) | One-line summary |
```
Remove the entry from **Gaps / To document** if this resolves one.
Skip this step when updating an existing page.

### Step 7 — Vocabulary capture (optional)

If the session introduced domain terminology, check `.claude/wiki/CONCEPTS.md`:
- Exists: add the term if missing.
- Doesn't exist: create it only if 2+ terms qualify.

Format: `**term** — definition in one sentence. Repo context if not obvious.`

### Step 8 — Fast audit (scoped to touched files)

Run only on the files written or updated this session — not the full wiki.

- **Check A** (index integrity): verify the page appears in INDEX.md Pages table (create path)
  or its existing row is still accurate (update path). Report ✗ if missing.
- **Check B** (broken links): scan the written/updated page for `[text](path)` links;
  verify each target file exists. Report ✗ with line reference.
- **Check C** (staleness on update): if updating an existing page, verify `date:` was refreshed.
  Report ⚠ if the old date is still present.

Print ✗ errors and ⚠ warnings only — suppress passing checks to keep output tight.
Then confirm: file path, create/update, INDEX.md touched, CONCEPTS.md touched, one sentence on what was captured.

---

## DEEP MODE (--deep) — Parallel tiered-agent capture

Use this for time-sensitive sessions where parallel execution matters.
Fidelity is comparable to default mode when A1 is thorough; default mode has a slight edge
on complex sessions since it reads the full conversation directly.

### Step A0 — Bail-out + bootstrap

Same as Steps 0 and 1 in default mode.

### Step A1 — Produce a rich session dossier (inline, before spawning)

Read the full conversation and write a dossier — do not compress into one-liners.
Fresh agents will have NO conversation context; this dossier is their only source of truth.

```
DOSSIER:
- Problem: <full description of symptom or question>
- Investigation: <steps taken, commands run, what was tried and why>
- Key evidence: <verbatim error messages, relevant code snippets, file paths>
- Resolution: <exact change made or decision reached, with rationale>
- Files touched: <repo-relative paths>
- Complexity: simple / moderate / complex
```

### Step A2 — Read INDEX.md

Read `.claude/wiki/INDEX.md` now — before spawning agents — so its Pages table can
be embedded in Agent 3's prompt.

### Step A3 — Spawn 3 agents in a single message (parallel)

Spawn all three as fresh **`general-purpose`** agents (NOT `subagent_type: fork` — forks
ignore the `model` parameter and run on the parent model). Embed the full dossier in each prompt.

**Agent 1 — Classifier** (model: haiku):
> "You are a metadata extractor for a software project wiki (small Python CLI project).
> Given this session dossier:
> [DOSSIER]
>
> Return ONLY a JSON object — no prose, no fences — with these fields:
> - track: 'bug' or 'knowledge'
> - categories: array — use the categories from .claude/wiki/CATEGORIES.md if it exists,
>   otherwise infer from .claude/wiki/ subdirectory names, otherwise use generic fallbacks
>   (bug-fixes, decisions, patterns, gotchas, developer-experience)
> - tags: array of 3-6 lowercase strings
> - severity: 'low'|'medium'|'high' (bug track only, else null)
> - related_files: array of repo-relative paths mentioned in the dossier
> - slug: kebab-case filename without extension (descriptive, not generic)"

**Agent 2 — Writer** (model: sonnet):
> "You are writing a structured wiki page for a software project (small Python CLI).
> Given this session dossier:
> [DOSSIER]
>
> Write the full page body using these sections:
> ## Problem / ## Root cause / ## Fix / ## Prevention / ## See also (only if relevant)
> Be specific — include exact error messages, file names, and command examples from the dossier.
> Return markdown only, no YAML frontmatter."

**Agent 3 — Related docs finder** (model: haiku):
> "Given this session dossier:
> [DOSSIER]
>
> And these existing wiki pages:
> [paste Pages table from INDEX.md]
>
> Return ONLY a JSON array — no prose, no fences — of 0-3 relative paths to the most
> related existing pages. Return [] if nothing is closely related."

### Step A4 — Assemble

Parse Agent 1 and Agent 3 outputs defensively:
- Strip any markdown fences (` ```json `, ` ``` `) and leading/trailing prose before parsing.
- If a required field from Agent 1 is missing or invalid, derive it yourself from the dossier
  rather than aborting.
- If Agent 3 returns malformed JSON, treat it as [].

Combine: frontmatter from Agent 1 + body from Agent 2 + See also links from Agent 3.
Apply the create-vs-update logic from Step 4 of default mode.

### Step A5 — Write + update INDEX.md + fast audit

Same as Steps 5–8 of default mode.

---

## AUDIT MODE (--audit) — Full wiki health check

Read all files in `.claude/wiki/` and run all 6 checks. No session capture.
Checks 1, 2, 3, 5 overlap with the fast audit but run corpus-wide here.
Checks 4 and 6 only run in full audit mode.

In the output, print ✓ passing checks (unlike fast audit which suppresses them).

### Check 1 — Index integrity

- Read INDEX.md Pages table. Verify each linked file exists on disk. Report missing files as ✗.
- List all `.md` files in `.claude/wiki/` (excluding `INDEX.md`, `CLAUDE.md`, `CONCEPTS.md`).
  Report any file not in the Pages table as ⚠ (orphan page).

### Check 2 — Broken internal links

Scan all wiki pages for `[text](path)` links. Verify each relative target file exists.
Report broken links as ✗ with source file and approximate line.

### Check 3 — Staleness signals

Flag pages as ⚠ stale if:
- `date:` frontmatter is older than 90 days **AND**
- The page references mutable figures (counts, version numbers, percentages).

Both conditions required — a page with no numbers but an old date is fine.
Flag only; do not auto-update.

### Check 4 — Coverage gaps (constrained)

Read `KNOWN_ISSUES.md` if it exists. Read any explicit `## Known issues`, `## TODO`, or
`## Gaps` sections in `CLAUDE.md` (project root). Do not infer gaps from general prose.

For each item found in those sources with no corresponding wiki page, report as 💡 with a
suggested category and slug.

### Check 5 — Gaps section accuracy

Read the **Gaps / To document** section in INDEX.md. For each listed gap, check whether
an existing wiki page already covers it. Report covered gaps as ⚠ (entry should be removed).

### Check 6 — Duplicate proximity

Scan page titles and summaries in INDEX.md. Flag pairs that share ≥3 tags or have nearly
identical titles as ⚠ with a note to review for merge.

### Audit output format

```
## Wiki Audit — YYYY-MM-DD

### ✗ Errors (must fix)
- <source>: <description>

### ⚠ Warnings (should fix)
- <source>: <description>

### 💡 Coverage gaps (consider documenting)
- <suggested path> — <why>

### ✓ Passing
- Index integrity: N pages, all present
- Internal links: N links checked, all valid
- Staleness: N pages checked, N flagged
- Gaps section: N items, N stale
```

End with: `N errors, N warnings, N gaps.`
