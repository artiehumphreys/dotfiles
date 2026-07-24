#!/bin/bash
IDLE=$((3 * 86400)) # 3 days
now=$(date +%s)
proj="$HOME/.claude/projects"

# nvim: kill if running >= 3 days (etime has a day field and days >= 3)
ps -axo pid,etime,command | awk '
  { days = (split($2, a, "-") == 2 ? a[1] + 0 : 0) }
  days >= 3 && /[n]vim/ { print $1 }
' | xargs -r kill 2>/dev/null

# claude: kill if the transcript for its cwd is untouched >= 3 days.
for pid in $(pgrep -x claude); do
  cwd=$(lsof -a -p "$pid" -d cwd -Fn 2>/dev/null | sed -n 's/^n//p')
  [ -n "$cwd" ] || continue
  slug=$(printf '%s' "$cwd" | sed 's#[/.]#-#g')
  newest=$(stat -f '%m' "$proj/$slug"/*.jsonl 2>/dev/null | sort -rn | head -1)
  [ -n "$newest" ] || continue
  [ $((now - newest)) -ge "$IDLE" ] && kill "$pid" 2>/dev/null
done
exit 0
