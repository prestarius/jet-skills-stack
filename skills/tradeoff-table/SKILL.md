---
name: tradeoff-table
description: Produce a side-by-side option comparison table with a clear recommendation. Use whenever the user is weighing approaches/tools/architectures ("X vs Y", "which should we use", "compare these options", "build vs buy") and would benefit from a structured tradeoff matrix rather than prose.
---

Output a Markdown table: columns = the candidate options, rows = decision criteria.
Default criteria (drop/add to fit the case): implementation complexity, operational burden,
scalability, cost (build + run), security posture, **EU data residency / GDPR fit**,
vendor lock-in, maturity/community, time-to-ship. Score each cell concretely (e.g. Low/Med/High
or 1–5), not vaguely.

After the table:
- **Recommendation** — one option, stated plainly.
- **Why** — the 2–3 criteria that decided it.
- **When to revisit** — the condition under which this choice should be re-opened.

Bias toward the simpler option unless a criterion clearly forces complexity. If you scored
a criterion, you must be able to justify it — verify current facts on the web for any tool/
version/pricing claim before scoring.
