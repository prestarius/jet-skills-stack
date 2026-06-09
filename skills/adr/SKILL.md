---
name: adr
description: Author Architecture Decision Records from a discussion, meeting notes, or a design debate. Use whenever the user wants to capture a decision, writes "record this as an ADR", finishes an architecture discussion, or asks to document why a choice was made. One ADR per decision.
---

Write one ADR per decision into `docs/adr/NNNN-kebab-title.md`, numbered sequentially
(read the directory to find the next number; never reuse a number). Use this structure:

```
# NNNN. <Decision title>
- Status: Proposed | Accepted | Superseded by ADR-XXXX | Deprecated
- Date: YYYY-MM-DD
- Deciders: <names/roles>

## Context
What forces are at play (technical, business, constraints). Neutral, no conclusion yet.

## Decision
The choice, stated in active voice: "We will …".

## Consequences
Positive, negative, and neutral results. Be honest about the costs.

## Alternatives considered
Each rejected option + the one-line reason it lost.
```

Mine the conversation/notes for the real forces and the real alternatives — an ADR with
no rejected alternatives is incomplete. If multiple decisions surfaced, write multiple files.
