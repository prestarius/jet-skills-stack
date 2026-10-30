#!/bin/zsh
# Supervisor for unattended jobs (launchd, cron): runs one job script and records how it ended in
# <repo>/jobs/runs/<day>.jsonl, one JSON line per run: at (local time with offset), job, status
# (ok|fail), owner, exit, seconds, error (last output line, on fail). Exit code is the job's.
# Usage: jobs/run.sh /abs/path/jobs/<job>.sh      owner: $JOB_OWNER, default launchd
# Lives in the working repo's jobs/ folder: the repo root is this folder's parent.
set -u
cd "$(dirname "$0")/.." || exit 1
job="$1"
name="${${job:t}%.sh}"
mkdir -p jobs/runs
start=$(date +%s)
out=$(mktemp)
"$job" >"$out" 2>&1
rc=$?
result=ok; [ "$rc" -ne 0 ] && result=fail   # `status` is read-only in zsh
python3 -I - "$name" "$result" "$rc" "$(( $(date +%s) - start ))" "$out" "${JOB_OWNER:-launchd}" >> "jobs/runs/$(date +%F).jsonl" <<'PY'
import datetime, json, sys
name, result, rc, secs, outf, owner = sys.argv[1:]
lines = open(outf, encoding="utf-8", errors="replace").read().strip().splitlines()
row = {"at": datetime.datetime.now().astimezone().isoformat(timespec="seconds"), "job": name,
       "status": result, "owner": owner, "exit": int(rc), "seconds": int(secs)}
if result != "ok":
    row["error"] = lines[-1] if lines else f"exit {rc}"
print(json.dumps(row, ensure_ascii=False))
PY
rm -f "$out"
exit "$rc"
