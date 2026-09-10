---
name: threat-model
description: Quick security pass over code or a design using OWASP Top 10 + STRIDE, findings by severity with a remediation each. Use when the user asks for a threat model, a security pass, or "what could go wrong security-wise" on a design or code path. Distinct from the bundled /security-review, which diffs the branch against origin.
argument-hint: "[code path / design to review]"
effort: high
---
Read `./CONTEXT.md` if present. Review `$ARGUMENTS`:
- OWASP Top 10 walk-through relevant to the surface (authz, injection, secrets, SSRF, etc.).
- STRIDE per trust boundary (Spoofing, Tampering, Repudiation, Info disclosure, DoS, Elevation).
Output findings by severity with a concrete remediation each. Never weaponize — defensive only.
