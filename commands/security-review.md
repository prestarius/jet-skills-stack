---
description: Quick security pass over code or a design using OWASP Top 10 + STRIDE.
argument-hint: "[code path / design to review]"
---
Read `./CONTEXT.md` if present. Review `$ARGUMENTS`:
- OWASP Top 10 walk-through relevant to the surface (authz, injection, secrets, SSRF, etc.).
- STRIDE per trust boundary (Spoofing, Tampering, Repudiation, Info disclosure, DoS, Elevation).
Output findings by severity with a concrete remediation each. Never weaponize — defensive only.
