---
name: release-notes
description: Turn git history since a tag or date into a changelog entry or release notes grouped by change type, in the project's changelog format. Use whenever the user asks for "release notes", "changelog", "what's in this release", "write the CHANGELOG entry", or is tagging a version. For a stakeholder progress update use status-report instead.
argument-hint: "[range or tag, e.g. v1.2.0..HEAD, or 'since last release']"
---

Write release notes from what actually shipped, not from commit messages verbatim.

1. **Pin the range.** Default to the last tag to `HEAD` (`git describe --tags --abbrev=0`);
   accept a range, tag, or date from `$ARGUMENTS`. State the range at the top.
2. **Read the changes, not just the log.** `git log --no-merges --format='%h %s%n%b' <range>`
   plus `git diff --stat <range>`; open the diff for anything whose commit message is vague.
   Outcomes, not commits: "Force pushes are now blocked by the guardrail hook", not "update hook".
3. **Match the house format.** Read `CONTEXT.md` (conventions) and the existing `CHANGELOG.md`;
   default to Keep a Changelog headings (**Added / Changed / Fixed / Removed / Security /
   Deprecated**) and semver. Keep the existing file's voice and heading style.
4. **Flag what the reader must act on.** Breaking changes, migrations, config changes, new
   defaults — first, with the one-line upgrade step. Never bury a breaking change in "Changed".
5. **Cross-link.** Issue/PR numbers from the tracker vocabulary in `CONTEXT.md`; ADRs by number.
6. **Output.** The entry as Markdown (or the edited `CHANGELOG.md` if asked), ready to paste.
   Don't invent items; if a commit is unclear, mark it `TODO: confirm` rather than guessing.

Omit "minor fixes and improvements" filler; either name the fix or drop the line.
