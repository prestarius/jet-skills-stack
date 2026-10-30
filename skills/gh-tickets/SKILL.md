---
name: gh-tickets
description: Drive GitHub tickets from the terminal with gh - create a public repo after the human says yes, open one issue per problem from a generated list or data, edit titles and bodies, close with a reason and a comment that quotes its source, and read the state back. Use when a task delivers tickets as GitHub issues, when the user says "open an issue per X", "file these as tickets", "close the tickets that are done". For splitting a plan into issues use plan-to-issues.
metadata:
  source: MEGA.dev S01E03 (tickets from a data export); moved to the stack 2026-10-30
---

# gh-tickets

Tickets are GitHub issues in one repo. Every step is a `gh` command; read `--help` for a flag before you use it, never guess it. `gh auth status` says whether you are signed in; signing in is the human's step.

## 1. The repo

Ask the human first: a repo they name, or a new one. Say who will see it. Then:

```
gh repo create <name> --public --description "<one line>"
```

If the permission classifier refuses a public repo, the durable fix is the allow rule `Bash(gh repo create *)` in `~/.claude/settings.json`; the human adds it or says yes to adding it. Run the bare `gh repo create` on its own line, not chained with `cd` or `find`, or the classifier reads the whole chain. Done when `gh api repos/<owner>/<name> --jq .visibility` prints `public`.

## 2. One issue per problem

Generate the titles and bodies with code from the same data the deliverable renders, so the count in the title and the number on the page cannot drift. Write each to a file, then:

```
gh issue create --repo <owner>/<name> --title "$(cat title.txt)" --body-file body.md
```

Put the count in the title in a fixed shape, such as `(379 reports)`. Record the issue numbers in the data file the page reads. Done when `gh issue list --json number,title` shows every problem once.

## 3. Changing and closing

```
gh issue edit <n> --title "..." --body-file body.md
gh issue close <n> --reason completed --comment "<what resolved it, with its source>"
gh issue close <n> --reason "not planned" --comment "<why not, with its source>"
gh issue comment <n> --body "<why it stays open>"
```

Close a ticket only when a source says the work is done, and quote that source in the comment. A problem nobody resolved stays open. Done when `gh issue list --state all --json number,state,stateReason` matches the sources.

## Gotcha

In zsh, `for pair in "1 parser"; do set -- $pair` does not split words. Use `case` or separate arrays. Long quoted one-liners of issue bodies break too: write bodies to files from a short Python script.
