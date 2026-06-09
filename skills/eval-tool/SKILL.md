---
name: eval-tool
description: Evaluate and recommend a tool, model, framework, or library with mandatory up-to-date web research. Use whenever the user asks "which X should I use", "is X any good", "evaluate X vs Y for us", or any tooling/model/library selection — never answer these from memory alone.
---

**Hard rule: web-search current facts first.** Versions, pricing, maintenance status, and
licenses drift; do not rely on training data for any of them.

Then evaluate against a criteria matrix (reuse the `tradeoff-table` skill for the matrix):
- Fitness for the stated use case
- **Self-hosting / EU data residency / GDPR** posture
- Cost (licensing + run) and pricing model
- Vendor lock-in and exit cost
- Maturity, release cadence, community/maintenance health
- Integration cost with the existing stack (read `CONTEXT.md` if present)

Output: a short matrix, then **Recommendation** + **Runner-up** + **Rejected (and why)**.
Cite sources for every factual claim. For hardware/accessories, link products from
botland.com.pl or amazon.pl.
