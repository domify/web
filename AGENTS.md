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

- Tape only where it pays. Each request has a `Tape.scope`
  (`Server#serve_connection`), opened after its first bytes are read so an
  idle connection holds no tape; `Intake` and `Response#write_http` use it.
  Move more onto the tape only when a benchmark, run interleaved against
  the current version, shows a clear gain, and put the numbers in the
  README's "Memory" section.
- Work on the request's tape, as Slim does: what web calls into (std/http,
  templates, JSON) takes the request's bytes as `TapeString` and writes
  into its `TapeWriter`, and opens no tape of its own. Copy to the heap
  only what a handler keeps. ris's CLAUDE.md has the whole model.
- No raw pointers in the handler API (no `send(pointer, count)`): a
  handler hands the response a `TapeString` or writes into a
  `TapeWriter`, and only the server takes `to_unsafe`, at the socket write.
  The tape checker does not follow a pointer out of its scope.
- Every line is at most 80 characters in documents and commit messages.

## Commits

- Do not add `Co-Authored-By: Claude …`, "Generated with Claude Code" or any
  other AI attribution to commit messages or pull request descriptions.
