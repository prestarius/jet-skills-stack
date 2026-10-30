---
name: job-supervisor
description: Put every unattended job (launchd, cron) behind one wrapper that records each run as a JSON line in jobs/runs/<day>.jsonl (time with offset, job, ok or fail, exit code, seconds, last error line), so a morning check or a digest can read what ran at night. Use when a repo gains a scheduled job, when the user asks "did it run", "log the jobs", "supervise the cron", or when a lesson or plan calls for a supervisor over automations.
metadata:
  source: MEGA.dev S01E04 "Try today" (supervisor over the harness's jobs); first run 2026-10-30
---

# job-supervisor

A job that runs unattended needs a record someone can read in the morning without opening the job's
own log. The record is one JSON line per run, appended to `jobs/runs/<day>.jsonl` in the working repo.
The job itself is not changed; the scheduler calls the wrapper, the wrapper calls the job.

## Install in a repo

1. Copy `${CLAUDE_SKILL_DIR}/scripts/run.sh` to `<repo>/jobs/run.sh` and make it executable. It
   finds the repo root as its folder's parent, so it must live in `jobs/`. Copy, do not symlink:
   launchd needs a path that is still there when the skills folder moves.
2. Point the scheduler at the wrapper, with the job as its argument:
   - launchd: `ProgramArguments` = `<repo>/jobs/run.sh`, `<repo>/jobs/<job>.sh`; then
     `launchctl unload` and `load` the plist and check with `launchctl print gui/$(id -u)/<label>`
     that `program` is the wrapper.
   - cron: `JOB_OWNER=cron <repo>/jobs/run.sh <repo>/jobs/<job>.sh`.
3. Self-check before trusting it (the wrapper returns the job's exit code):
   a script that exits 3 with a line on stderr must give a `fail` row with that line as `error`;
   a script that exits 0 must give an `ok` row without `error`; then run the real job by hand once.
   Delete the two synthetic rows so the day file holds real runs only.
4. Commit `jobs/run.sh`, the plist and the first `jobs/runs/<day>.jsonl`; index `jobs/` in the README.

## The record

```json
{"at": "2026-10-30T05:01:05+01:00", "job": "0501", "status": "ok", "owner": "launchd", "exit": 0, "seconds": 0}
{"at": "2026-10-30T04:00:01+01:00", "job": "backup", "status": "fail", "owner": "launchd", "exit": 1, "seconds": 12, "error": "quota exceeded"}
```

`at` carries the offset so two machines' records can be compared. `error` is the job's last output
line, which is usually the message that matters. A missing day file means nothing ran, which is
itself the finding.

## Reading a night

```sh
cat jobs/runs/$(date +%F).jsonl
```

Count ok/fail per job from the rows, not from the jobs' own logs. A digest page or a morning routine
reads the same file.

## Limits

The wrapper records; it does not retry, alert or time out. Add those only when a night shows they
are needed, and keep them in the wrapper, not in each job.
