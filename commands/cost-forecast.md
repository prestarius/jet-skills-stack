---
description: Forecast token/usage cost for an LLM workload from usage signals; produce a wiki-ready table.
argument-hint: "[usage data or assumptions: users, requests, model mix]"
---
Translate `$ARGUMENTS` into a cost forecast. **Web-search current model pricing first** —
never use remembered prices. Build scenarios (e.g. cheaper-model-heavy vs premium-heavy),
show per-user and total monthly cost, state every assumption. Output a Markdown table suitable
to paste into a wiki. Note this is an estimate, not financial advice.
