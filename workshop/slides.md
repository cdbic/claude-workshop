---
marp: true
theme: default
paginate: true
title: "Claude: From First Chat to AI Brain"
---

<!-- Render: `marp workshop/slides.md -o slides.html` (or present from VS Code Marp extension) -->

# Claude: From First Chat to AI Brain

A one-day hands-on workshop

09:30 – 17:00 · in-person + remote

---

## Today's roadmap

| When | What | You'll be… |
|---|---|---|
| Morning | Claude 101 + claude.ai labs | **doing** (free tier) |
| Afternoon | Claude Code, skills, memory, Cowork | **watching** (needs paid tier) |

- Everything hands-on today works on a **free** claude.ai account
- The afternoon shows where the ladder goes — nothing to install

<!-- Welcome block, 15m. Set expectations explicitly: hands-on = free tier only. Ask remote attendees to confirm they can see/hear. Point at the chat channel for questions. -->

---

# Part 1 · Claude 101

---

## What is an LLM?

- A model trained to predict the next token over enormous amounts of text
- "Autocomplete" is the mechanism — **reasoning is the emergent behavior**
- It doesn't look things up in a database; it generates from learned patterns
- Consequence: brilliant at synthesis, can be confidently wrong on facts

<!-- One analogy, no math: a pianist who has practiced millions of songs doesn't retrieve sheet music — they play what fits. Keep to 5 min. -->

---

## Tokens: the unit of everything

- Models read and write **tokens** — word fragments, ~3-4 characters of English each
- Everything is billed, limited, and measured in tokens
- **Context window** = how many tokens the model can hold in one conversation
- When the window fills up: older content is dropped or summarized

**Live demo:** count tokens on a real document via the token-counting API

<!-- Demo: `ant messages count-tokens --model claude-sonnet-5 --message '{role: user, content: "@./README.md"}'` or the Console workbench which shows usage per run. Show the same sentence in English vs. code vs. emoji — different token counts. -->

---

## Sessions and state

- A conversation (session) = the full message history sent back every turn
- The model itself is **stateless** — the app re-sends the history each time
- Long conversation → bigger context → slower, costlier, eventually compacted
- Practical takeaway: one topic per conversation; start fresh when switching

---

## Prompting basics

Three levers that matter more than any "magic words":

1. **Specificity** — audience, format, length, constraints
2. **Examples** — show one input/output pair, get the pattern back
3. **Iteration** — treat the first answer as a draft; refine in follow-ups

**Live:** 3 before/after prompt pairs

<!-- Before/after pairs: (1) "write a blog post" vs. audience+tone+length spec; (2) extraction task without vs. with an example; (3) one-shot vs. iterate-twice. Run them live in claude.ai. -->

---

## Failure modes — honest expectations

- **Hallucination**: fluent, confident, wrong — always verify facts that matter
- **Knowledge cutoff**: training data ends months ago; web search closes the gap
- **Context loss**: very long chats degrade — the model "forgets" early details
- Rule of thumb: great **thought partner**, unreliable **source of record**

---

## Model tiers, in one breath

- **Haiku** — fastest, cheapest: classification, quick lookups
- **Sonnet** — the balanced default: most day-to-day work
- **Opus** — deep reasoning: hard, long-horizon problems
- (Frontier tier above that exists for the hardest work)

You rarely need to think about this on claude.ai — the default is fine.

<!-- Current family names if asked: Haiku 4.5, Sonnet 5, Opus 4.8, Fable 5 at the frontier. Don't dwell — free tier users get the standard models; paid tiers add options. -->

---

# Part 2 · claude.ai Labs

*(hands-on — see your lab handout)*

---

## Lab 1 — chat, artifacts, files (75 min)

1. **Iterative prompting** — refine a writing task over 2-3 turns
2. **Artifacts** — have Claude build something interactive
3. **CSV analysis** — upload data, get charts + insights

Grab the handout + `coffee_sales.csv`. Raise a hand (or post in chat) when stuck.

<!-- Roam the room; co-host triages remote chat. Exercise 2 is the wow-moment — budget the most float time there. -->

---

## Lab 2 — search, connectors, memory (45 min)

4. **Web search grounding** — ask something the training data can't know
5. **Connectors** — plug Claude into a service you already use

Also notice: Claude **remembers across conversations** — that memory idea scales all the way up to this afternoon's "AI brain".

---

# Part 3 · Why an agent, not just chat

---

## The ceiling of pure chat

Chat can't:

- read or write **your files**
- run **commands** and see what happened
- **iterate against reality** — edit, test, fix, repeat

You are the copy-paste layer. That's the bottleneck.

---

## Agentic coding

> An agent = a model in a loop with **tools**, working toward a **goal**

- Reads your code, edits files, runs tests, reads the failures, tries again
- You review and steer; it does the mechanical loop
- This is Claude Code — which is what we'll watch next

<!-- Bridge block, 20m. End on: "everything you've done today by hand — the agent does in a loop." Then break, then demo. -->

---

# Part 4 · Demos

*(watch-along — Claude Code needs a Pro plan or API key, links in the cheat sheet)*

---

## Demo 1 — Claude Code CLI (60 min)

- Install, first session, where tokens show up
- The loop: prompt → read/edit/run → verify → repeat
- Live build: add a `search` command to a small notes CLI

## Demo 2 — Skills, schedules & the AI brain (45 min)

- **Skills**: reusable workflows in a markdown file
- **Schedules**: agents that run on a cron, without you
- **Memory**: CLAUDE.md, per-project wikis, persistent memory dirs

## Demo 3 — Claude Cowork (20 min)

- Autonomous desktop agent — same project, one more layer of autonomy

---

# Wrap-up

---

## The ladder

1. **Free chat** (today's labs) — writing, analysis, artifacts, search
2. **Pro** — Claude Code, Cowork, Projects, more models
3. **Your AI brain** — skills + schedules + memory, compounding over time

Start tonight on rung 1. The cheat sheet has every link.

## Q&A

<!-- 15m incl. buffer. Hand out / link the cheat sheet before Q&A so people leave with it. -->
