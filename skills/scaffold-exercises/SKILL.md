---
name: scaffold-exercises
description: Generate a set of hands-on coding exercises for a training or workshop — each with a task brief, starter code, and a worked solution — that build incrementally. Use whenever the user is preparing a workshop, lab, or teaching session, asks for "exercises", "a lab", "hands-on material", or wants to turn a topic into practice tasks. Pairs with the slide-deck skill's lab slide.
---

Produce a directory of self-contained exercises that progress from easy to hard.

Before generating, settle (ask once if unspecified): the **topic**, the **number** of exercises,
the **language/stack** (default to the stack in `./CONTEXT.md`, else Python on macOS), and whether
solutions should be included.

Layout (one folder per exercise, zero-padded, ordered):
```
exercises/
├── 01-<slug>/
│   ├── README.md        # the task: goal, requirements, acceptance criteria, hints
│   ├── starter/         # runnable skeleton the learner edits (failing or stubbed)
│   └── solution/        # the worked answer (omit if solutions not wanted)
├── 02-<slug>/
└── ...
```

Each exercise's `README.md` has fixed sections: **Goal** (one sentence), **Background** (only what's
needed), **Task** (numbered, concrete), **Acceptance criteria** (how the learner knows they're done —
prefer a command to run or a test that passes), and **Hints** (collapsible/last, so they can avoid them).

Rules:
- **Build incrementally.** Each exercise assumes the previous one's concepts; introduce one new idea at a time.
- **Make them runnable.** Starter code must execute (even if the test fails); include the exact run command, macOS-first.
- **Solutions are complete and idiomatic**, matching the stack's conventions — not sketches.
- Keep each exercise small enough to finish in the session's per-exercise time budget; if the user
  gives a total duration, size and number them to fit.
