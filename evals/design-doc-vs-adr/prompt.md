---
name: adr fires for record-this-decision, not design-doc
tags: [trigger, routing]
plugins: ["../.."]
runs: 2
max_turns: 8
timeout_seconds: 180
allowed_tools: [Read, Write, Glob]
---
We decided: events go through an outbox table in the service DB and a relay publishes to Kafka; we rejected dual-write and CDC. Record this as an ADR.
