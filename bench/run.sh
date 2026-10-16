#!/bin/sh
# Builds bench/app.ri with --release and loads it with ab: requests per
# second for / and /page, and the server's peak RSS. Usage: bench/run.sh
# [rounds]. Prints one line per round and path.
set -eu
cd "$(dirname "$0")/.."
RIS="${RIS:-ris}"
export IYI_PATH="$PWD:$("$RIS" env RIS_PATH)"
rounds="${1:-5}"
bin=$(mktemp /tmp/web-bench.XXXXXX)
pid=; trap 'kill "$pid" 2>/dev/null || true; rm -f "$bin"' EXIT INT TERM
"$RIS" build --release bench/app.ri -o "$bin"
"$bin" -p 3999 >/dev/null 2>&1 &
pid=$!
sleep 1
for round in $(seq "$rounds"); do
  for path in / /page; do
    rps=$(ab -q -k -c 64 -n 100000 "http://127.0.0.1:3999$path" \
      | awk '/Requests per second/ {print $4}')
    echo "round $round $path $rps req/s"
  done
done
echo "peak RSS $(awk '/VmHWM/ {print $2, $3}' /proc/$pid/status)"
