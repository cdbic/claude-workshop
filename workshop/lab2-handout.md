# Lab 2 — Search, Connectors, Memory (45 min)

Still all free-tier. Same rules: hand up in the room, chat channel if remote.

## Exercise 4 — Web search grounding (15 min)

Goal: see the difference between training knowledge and live search.

1. In a new conversation, ask something that *must* be current, e.g.:
   ```
   What happened in tech news this week? Cite your sources.
   ```
2. Notice Claude searches the web and links sources — click one to verify.
3. Now ask a question about your own domain/industry that needs fresh data.
4. Compare: ask the same question with `Don't search the web, answer from memory.` — spot what's missing or stale.

**Done when:** you've seen one answer with sources and understand when Claude decides to search.

## Exercise 5 — Connectors (25 min)

Goal: plug Claude into a service you already use.

1. Open **Settings → Connectors** in claude.ai.
2. Connect **Google Drive** (primary) — or **GitHub** if you don't use Drive.
3. Back in a conversation, ask something that needs the connector, e.g.:
   ```
   Search my Drive for the most recent document I worked on and summarize it.
   ```
   or for GitHub:
   ```
   Look at my most recently updated repo and describe what it does.
   ```
4. Try one real task from your actual work: "find X", "summarize Y", "compare these two docs".

**If the first connector misbehaves**, switch to the other one — don't burn the whole exercise on auth issues.

**Done when:** Claude has successfully read something from *your* connected service.

## Notice: memory

Claude remembers context **across conversations** on the free tier — preferences you state, facts about what you're working on. You'll see this afternoon how the same idea scales up: memory files, project wikis, a persistent "AI brain" that compounds over weeks.

## Stretch

- Connect a second service and ask a question that spans both.
- Tell Claude a durable preference ("always answer me in bullet points") and test it in a brand-new conversation.
