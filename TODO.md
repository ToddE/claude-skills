# TODO

Planned work for this repo.

## Architect Review skill

**Status**: two personas shipped (The Pragmatic Modulith Architect, The Assembler), with an
opt-in debate feature between them. See `product-management/skills/architect-review/`.

**Open**:
- The Assembler is a first draft, built as a deliberate, good-faith counterweight to the
  other persona's philosophy rather than from examples. Refine it as cases (won or lost)
  of vendor-first architecture become available, the same way the first persona's file
  improved once grounded in transcripts.
- A third persona hasn't been discussed yet. No need to add one for its own sake; wait
  until a specific gap in coverage shows up (e.g. a security-first or compliance-first
  architect, if the two existing personas' shared blind spots turn out to matter for an
  initiative).

## GitHub Pages examples player

`examples.html` plays back a run's `dialogue.md` turn by turn, or jumps straight to a
curated list of that run's artifacts. Adding a new run to the picker is one entry in the
`EXAMPLES` array in that file.

**Open**:
- The `2026-09-22-claude-skills-meta` run has no `dialogue.md` (see the known gap in
  `product-management/test/README.md`), so its gallery entry has `hasDialogue: false` and
  jumps straight to results. Worth writing a `dialogue.md` for it retroactively if that run
  ever gets revisited, so all gallery entries can play back.

## Pipeline testing

**Status**: six end-to-end pipeline runs plus a standalone-mode verification run, kept in
`product-management/test/output/`. See `product-management/test/README.md` for the folder
convention and `product-management/test/GENERATE-EXAMPLE.md` for the repeatable process
behind generating a new one.

**Open**:
- The live, chained handoff sequence between skills (discovery &rarr; uml &rarr;
  test-cases/requirements &rarr; architect-review actually run back-to-back in one
  session), and the unavailable-skill fallback specifically, remain untested end-to-end.
  Every attempt so far has hit a naming collision where `working-backwards-prfaq` resolves
  to an unrelated same-named skill (or nothing at all) before the real chain can start;
  see `product-management/README.md`'s Install section. A follow-up run needs the
  `product-management` plugin actually installed (or every skill invoked by
  fully-qualified name) to exercise the real chain.
- Skill discoverability via the harness's synced `.claude/skills/` has been inconsistent:
  the available-skills list has fluctuated between showing all seven skills and showing as
  few as one or three, with no action taken on this repo's side. Not something this repo
  controls, but worth knowing if a future test run reports a skill as "unavailable" that
  should exist: distinguish a true gap from this same sync flakiness before treating it as
  a bug.
- `working-backwards-prfaq`'s handoff offer to `use-case-discovery` at the end of its
  Step 3 has not been verified in a live run, for the same collision reason above.
- The `2026-09-22-claude-skills-meta` run still only has one use case, which isn't
  realistic; most initiatives have several. Worth extending the same way later runs did
  (separate, cross-linked files) if that run gets revisited.
- Even in runs with multiple use cases, downstream artifacts don't always cover every one
  from the start. Worth checking coverage explicitly when reviewing a new run.
- Possible use-case-uml spec gap: its self-check requires every listed Actor to appear in
  the Basic Path specifically. An actor that only appears in an Exception Path (e.g. an
  escalation contact, reached only on failure) is a normal pattern but currently fails that
  check. Worth deciding whether the rule should allow an Actor to be used anywhere in the
  document, not just the Basic Path, before this comes up again.
