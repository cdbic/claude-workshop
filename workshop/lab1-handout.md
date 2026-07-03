# Lab 1 — Chat, Artifacts, Files (75 min)

Everything here works on a **free** claude.ai account. Work at your own pace; raise a hand (in the room) or post in the chat channel (remote) if you get stuck.

## Setup check (5 min)

- Log in at https://claude.ai
- Start a new conversation, send "hello", confirm you get a reply

## Exercise 1 — Iterative prompting (15 min)

Goal: feel the difference between a vague prompt and a specific, iterated one.

1. Send exactly: `Write a short post announcing a new feature.`
2. Look at the result — notice everything it had to guess (what feature? for whom? what tone?).
3. Now send:
   ```
   Rewrite it: the feature is dark mode in a note-taking app, the audience
   is existing users reading a changelog, casual tone, max 100 words,
   end with one emoji.
   ```
4. One more refinement of your choice (shorter, funnier, different audience).

**Done when:** you have a version you'd actually publish, and you've changed direction at least twice without starting over.

## Exercise 2 — Artifacts (25 min)

Goal: get Claude to build something interactive, live.

1. Send:
   ```
   Build me an interactive tip calculator: bill amount, tip percentage
   slider, split-between-N-people. Make it look nice.
   ```
2. Claude renders it as an artifact next to the chat — try it out.
3. Ask for changes in plain language: a dark theme, a currency switcher, rounding rules.
4. Free choice: replace the calculator with anything — a chart, a mini game, a quiz.

**Done when:** you've iterated on a working interactive artifact at least twice.

## Exercise 3 — File upload + analysis (25 min)

Goal: turn a raw CSV into insights without writing a line of code.

1. Download `coffee_sales.csv` (link shared in chat / on screen).
2. Attach it to a new conversation and send:
   ```
   Analyze this sales data. What are the top products, how do weekdays
   compare to weekends, and is there anything surprising? Show a chart.
   ```
3. Claude runs actual code against your file — expand the analysis blocks to see it.
4. Follow up: `Which payment method is growing? Chart revenue by category over time.`

**Done when:** you have at least one chart and one insight you didn't spot by eyeballing the file.

## Stretch (if you finish early)

- Ask Claude to write a one-paragraph executive summary of the CSV findings.
- Combine exercises: have it build an interactive dashboard artifact from the CSV numbers.
