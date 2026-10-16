# Working on web

web is a native ris module: an HTTP/1.1 web framework, ported from the iyi
module iyi-web. The README is for applications; this page is for changing
web itself.

## Checks

```sh
./check.sh            # every *_test.ri under web/ and examples/
bench/run.sh 5        # requests per second and peak RSS, --release
```

## Rules

- Tape only where it pays: the buffered response is serialised onto the
  tape (`Response#write_http`, `Server#send`). Keep other per-request data
  on the heap unless a benchmark, run interleaved against the heap version,
  shows a clear gain; put the numbers in the README's "Memory" section.
- Every line is at most 80 characters in documents and commit messages.

## Commits

- Do not add `Co-Authored-By: Claude …`, "Generated with Claude Code" or any
  other AI attribution to commit messages or pull request descriptions.
