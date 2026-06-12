---
name: postmortem
description: Write a blameless incident postmortem — impact, timeline, contributing factors, what went well/poorly, concrete follow-up actions. Use whenever the user says "postmortem", "incident review", "RCA", "write up this outage", or when a diagnose session ends on an incident that deserves a durable record.
---
Read `./CONTEXT.md` if present. Gather facts from the conversation (especially any diagnose
output), logs, and whatever the user provides. One incident per document.

Structure:
1. **Summary** — severity, duration, user impact, one-line cause. Up front, no suspense.
2. **Timeline** — absolute timestamps (date + time + zone), from first signal to resolution.
   Include detection lag and mitigation time explicitly.
3. **Contributing factors** — plural by default; resist the single "root cause". Cover the
   trigger, why defenses didn't catch it, and what made recovery slow.
4. **What went well / what went poorly** — honest, short.
5. **Follow-up actions** — concrete and verifiable, each preventing a contributing factor or
   shortening detection/recovery. Written so the to-issues skill can turn them into tickets.

Rules:
- Blameless: name systems, gaps, and missing guardrails — never people. "The deploy pipeline
  allowed X", not "Y pushed without checking".
- Facts only; mark every unknown `TODO:` instead of reconstructing a plausible story.
- If the fix isn't verified yet, say so in the summary.

Offer (opt-in): file via the obsidian-note skill; capture a durable decision via the adr skill;
turn follow-ups into tickets via the to-issues skill.
