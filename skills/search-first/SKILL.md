---
name: search-first
description: Before writing custom code for a new utility, dependency, or integration, search for an existing solution first — in the repo, in package registries, and on the web — then decide whether to adopt, extend, compose, or build. Use whenever the user is about to build something likely already solved ("is there a library for this", "should we build or buy", "implement X"), or starts a feature that smells like a solved problem.
---

Don't reinvent a solved problem, and don't bolt on a heavy dependency for a trivial one. Research, then decide.

1. **Preflight — name your channels.** State which search channels you can actually use (repo
   `Grep`/`Explore`, package registries, GitHub, `WebSearch`) and say honestly if one is unavailable.
2. **Need analysis.** Define the required functionality in one or two sentences and the constraints:
   language/framework/runtime (read `./CONTEXT.md`; default to the stack there — for this profile,
   PyPI for Python and NuGet for .NET), license posture, EU data-residency/GDPR needs.
3. **Search in parallel.**
   - **Repo first** — is it already solved internally? (`Grep`/`Explore` for existing utilities/patterns.)
   - **Registries** — PyPI / NuGet / npm as the stack dictates.
   - **Web / GitHub** — prior art, maintained libraries, known approaches. Use the `Explore` agent for breadth.
4. **Evaluate the candidates.** Score on fitness, maintenance/release cadence, community, docs,
   **license + self-hosting/GDPR posture**, and dependency footprint. For more than two candidates,
   use the `tradeoff-table` skill; for a single tool decision, defer to `eval-tool`. Verify versions
   and maintenance status on the web — don't trust memory.
5. **Decide, with rationale.** Pick one:
   - **Adopt as-is** — it fits; wire it in.
   - **Extend** — adopt + a thin wrapper for the gap.
   - **Compose** — combine a couple of focused packages.
   - **Build** — only after confirming nothing suitable exists, *or* the need is trivial enough that a
     dependency would cost more than it saves (simplicity-first).

Output: the candidates considered, the decision, and concrete integration/installation guidance.
Cite sources for any maintenance/version/license claim.
