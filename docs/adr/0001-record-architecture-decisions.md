# 0001. Record architecture decisions
- Status: Accepted
- Date: 2026-06-08
- Deciders: Jet

## Context
This stack will accumulate non-obvious design choices over time (skill boundaries, the
company-agnostic constraint, full-vs-stub policy, install mechanics). Without a durable record,
the reasoning behind each choice is lost and gets re-litigated. We want a lightweight,
version-controlled way to capture decisions next to the code they affect.

## Decision
We will record architecture decisions in `docs/adr/` as numbered Markdown files, one ADR per
decision, using the template in `0000-template.md`. Numbers are sequential and never reused; a
superseded ADR is marked, not deleted.

## Consequences
- Positive: decisions and their rejected alternatives are discoverable and durable; new
  contributors (human or agent) can reconstruct intent.
- Positive: the `adr` skill automates authoring, lowering the cost of recording a decision.
- Negative: a small ongoing discipline cost — decisions must actually be written down.
- Neutral: ADRs are append-mostly; the directory grows monotonically.

## Alternatives considered
- **Decisions in a wiki / external doc** — drifts from the code, not version-controlled with it.
- **Commit messages only** — too granular and unstructured to capture forces and alternatives.
- **No formal record** — the status quo we are explicitly rejecting.
