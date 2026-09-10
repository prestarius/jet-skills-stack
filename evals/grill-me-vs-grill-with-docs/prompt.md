---
name: grill-me fires and asks exactly one question
tags: [trigger, routing]
plugins: ["../.."]
runs: 2
max_turns: 4
timeout_seconds: 120
---
Poke holes in this plan: we'll move session storage from Postgres to Redis next sprint to cut p99 latency, keeping Postgres as a fallback for a month.
