---
name: humanizer must not fire for a typo fix
tags: [no-trigger]
plugins: ["../.."]
runs: 2
max_turns: 4
timeout_seconds: 120
---
Fix the typos in this sentence and nothing else: "Teh deploy pipline runs evry night at 2am and emails the on-call enginer."
