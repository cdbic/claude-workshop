# ============================================================================
# SHOWCASE ARTIFACT — READ, DON'T RUN.
#
# Windows (PowerShell) counterpart of ai-brain-setup.sh: bootstraps the
# "AI brain" three-system architecture shown in the 15:40 workshop segment.
# Idempotent — write-if-absent for all skill files; never overwrites content.
#
# Why you should NOT run it as-is:
#   - It writes 8 skills into YOUR global ~\.claude\skills\ directory.
#   - The final cleanup step DELETES any flat *.md files in ~\.claude\skills\
#     (the presenter's convention is one-directory-per-skill; yours may not be).
#   - It creates a personal knowledge-hub directory layout under ~\Developer.
#
# If you want this setup, read it, adapt the paths, then run your version.
# (Your execution policy will likely stop a blind run anyway — good.)
# ============================================================================

$ErrorActionPreference = 'Stop'

$SkillsDir = Join-Path $HOME '.claude\skills'
$HubDir    = Join-Path $HOME 'Developer\claude-work-hub'

function Write-Skill($Name, $Content) {
    $dir = Join-Path $SkillsDir $Name
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    $file = Join-Path $dir 'SKILL.md'
    if (-not (Test-Path $file)) {
        Set-Content -Path $file -Value $Content -Encoding UTF8
        Write-Host "  created $Name"
    } else {
        Write-Host "  exists  $Name (skipped)"
    }
}

Write-Host '==> Hub structure'
foreach ($d in 'raw', 'wiki', 'scripts', 'templates\project-wiki') {
    New-Item -ItemType Directory -Force -Path (Join-Path $HubDir $d) | Out-Null
}

Write-Host '==> Skills'

Write-Skill 'grill-me' @'
---
name: grill-me
description: Drill down on a task or plan using probing questions until we reach a shared, precise understanding. Use when the user wants to stress-test a plan, clarify a vague task before implementation, or mentions "grill me" or "drill me".
---

Ask one probing question at a time to surface hidden decisions, assumptions, and constraints. If a question can be answered by reading the codebase, read it instead of asking.

Keep asking until you can produce this brief without guessing:

**SPEC** — what exactly to build, broken into verifiable segments
**VERIFIER** — concrete, measurable criteria for "done"
**ENVIRONMENT** — key constraints, existing patterns to follow, what must not break

Do not start implementing until the brief is agreed upon.
'@

Write-Skill 'config-audit' @'
---
name: config-audit
description: Audit CLAUDE.md (global + project), knowledge base, skills, and guardrails for the top 5 gaps — file, problem, exact fix, and hook flag.
---

Check my CLAUDE.md (global + project), my knowledge base (`~/claude-work-hub/wiki/` and `.claude/wiki/INDEX.md`), my skills, and my guardrails (`settings.json` hooks + allow lists). For each of the top 5 gaps, name the file, the problem, and the exact fix — and flag which risky actions need a hook so I can't bypass them.
'@

Write-Skill 'loop-candidates' @'
---
name: loop-candidates
description: Audit workspace and conversation history to rank recurring tasks as loop automation candidates using the 4-Condition Test.
---

Audit my entire workspace and my conversation history. Based on what I do every week, what tools and files I already have set up, and what tasks I repeat — run the 4-Condition Test on each candidate:

1. Does it repeat?
2. Can a rule decide if it's done?
3. Can I afford a few wasted runs?
4. Does AI have the data and tools it needs?

Rank them as loop candidates and tell me which one to build first.
'@

Write-Skill 'build-loop' @'
---
name: build-loop
description: Build a loop orchestration skill from a brief or via interview. Output always includes Loop Training Mode, step-skipping, and a retry cap.
---

Build a single orchestration skill from a task brief.

**If the user provided a brief** (Task + Goal + Verification), build immediately.
**If not**, interview them with these questions one at a time:
1. What should the loop do? (one sentence)
2. What does done look like? (the goal)
3. What rule confirms it's done? (the verification check)
4. What are the steps each iteration?
5. What's the trigger — schedule, event, or on-demand?

Once you have all five answers, write `~/.claude/skills/<slug>/SKILL.md` with this structure:

---

```
# LOOP TRAINING MODE: ON
# Flip to OFF to run autonomously (done-rule checks and retry cap still apply)
TRAINING_MODE=ON
MAX_RETRIES=5
```

Then the skill body:
- State the task, goal, and done-rule at the top
- List the steps
- For each iteration:
  - **If TRAINING_MODE=ON**: pause before each step and wait for approval; skip any step whose done-check already passes; only retry steps that fail; stop after MAX_RETRIES attempts
  - **If TRAINING_MODE=OFF**: run autonomously; keep done-rule checks and retry cap
- On hitting MAX_RETRIES: stop and report what passed, what failed, what needs manual intervention

Keep the skill small enough to read in one sitting. No scaffolding, no boilerplate beyond the training mode header.
'@

Write-Skill 'graduate-loop' @'
---
name: graduate-loop
description: Flip TRAINING_MODE from ON to OFF in a loop skill after it has run successfully N times in a row. Keeps done-rule checks and retry cap intact.
---

Usage: `/graduate-loop <skill-name> [N]` — e.g. `/graduate-loop babysit-mr 3`

N defaults to 3 if not specified.

1. Find the skill at `~/.claude/skills/<skill-name>/SKILL.md` (or `.claude/skills/<skill-name>/SKILL.md` for project skills).

2. Confirm the skill has `TRAINING_MODE=ON` in its header. If it's already OFF, report that and stop.

3. Ask the user: "Has `/<skill-name>` run successfully [N] times in a row with Training Mode ON?"
   If yes, proceed. If no, stop and tell them how many more runs are needed.

4. Edit the file: flip `TRAINING_MODE=ON` → `TRAINING_MODE=OFF`. Touch nothing else — done-rule checks and MAX_RETRIES stay exactly as written.

5. Confirm: "Graduated `/<skill-name>` to autonomous mode. Done-rule and retry cap unchanged."

Do not modify any step logic, done-rules, or MAX_RETRIES value.
'@

Write-Skill 'skill-gaps' @'
---
name: skill-gaps
description: Audit workspace and repeated tasks to identify which ones would benefit from a saved skill file — with a suggested SKILL.md for each.
---

Look at my workspace (`~/.claude/skills/`, `.claude/skills/`, `~/claude-work-hub/`, memory, and conversation history) and the tasks I do repeatedly. Tell me which ones would benefit from a saved skill file that doesn't exist yet.

For each candidate, produce a ready-to-save `SKILL.md` block that documents:
- The task (what it does)
- My preferences and conventions for this project (from memory and CLAUDE.md)
- What counts as "done" so any loop or one-shot invocation knows when to stop

Format each suggestion as:

**`/skill-name`** — one-line description
```markdown
---
name: skill-name
description: ...
---
<skill body>
```

Skip skills that already exist. Prioritise tasks that are high-frequency, have clear done-rules, and carry project-specific context that a fresh session would otherwise miss.
'@

Write-Skill 'skill-to-validator' @'
---
name: skill-to-validator
description: Analyze existing skills and suggest how each could be tweaked to emit a pass/fail verdict so a loop can call them as validators.
---

Read all skills in `~/.claude/skills/` and `.claude/skills/`. For each skill that performs a task or check but doesn't currently emit a clear pass/fail verdict, explain what tweak would turn it into a validator a loop can poll.

A validator skill must:
1. Run the check
2. Print either `✅ PASS: <reason>` or `❌ FAIL: <reason>` as its final line
3. Exit so a loop knows whether to stop, retry, or escalate

For each candidate, output:

**`/skill-name`** — what it does today → what the validator version checks
> **Tweak:** one sentence describing the change (add a final status line, surface exit code, check a specific condition)
> **Loop pattern:** `/loop 2m /skill-name` stops when it sees PASS — use for [scenario]

Skip skills that are already validators or that are inherently one-shot reports with no checkable outcome (e.g. `/ponytail-audit`, `/skill-gaps`).
'@

Write-Skill 'add-verifier' @'
---
name: add-verifier
description: Update a loop orchestration skill to run final verification in a separate subagent with a fresh context window. The verifier scores 1-10 and only marks the loop done if the score clears a threshold.
---

The user will name a skill to upgrade, e.g. `/add-verifier babysit-mr` or `/add-verifier ecs-run`.

Read the target skill's `SKILL.md`. Then rewrite it so the loop structure becomes:

1. **Worker step** — the existing task logic (unchanged)
2. **Verifier step** — a separate subagent spawned with the Agent tool (`subagent_type: "general-purpose"`) that receives ONLY the worker's output, not the worker's context. The verifier prompt must:
   - Describe what "good output" looks like for this specific task
   - Score the output 1–10 with explicit criteria
   - Return a structured verdict: `{ score: N, reason: "...", done: true/false }`
3. **Gate** — the loop continues if `score < threshold`; stops if `score >= threshold`

Ask the user for the threshold (default: 7) before rewriting, unless they already specified it.

The verifier must be genuinely independent — it receives the worker output as a quoted block, not via shared memory or tool history. Frame the verifier prompt as: "You are reviewing this output cold. You have no context about how it was produced. Score it 1-10 on [specific criteria]."

After rewriting, save the updated `SKILL.md` in place (same path) and show a diff of what changed.

**Key constraint:** never let the worker agent call the verifier — the orchestrating skill spawns both sequentially, passes the worker's output explicitly to the verifier as text.
'@

Write-Host ''
Write-Host '==> Cleanup orphan flat skill files'
Get-ChildItem -Path $SkillsDir -Filter '*.md' -File -ErrorAction SilentlyContinue | ForEach-Object {
    Remove-Item $_.FullName
    Write-Host "  removed $($_.Name)"
}

Write-Host ''
Write-Host 'Done. Run /reload-skills in Claude Code to pick up any new skills.'
