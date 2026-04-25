#!/bin/bash
# Kill nvim processes running >= 3 days
ps -axo pid,etime,command | awk '
  /[n]vim/ {
    n = split($2, a, "-")
    if (n == 2 && a[1] + 0 >= 3) print $1
  }
' | xargs -r kill 2>/dev/null
