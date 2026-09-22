# TODO

Planned work for this repo.

## Architect Review skill

**Status**: two personas shipped (The Pragmatic Modulith Architect, The Assembler). The
multi-persona pattern this skill was built for is now validated: two different
philosophies, applied to the same input, produce different recommendations rather than the
same advice in a different tone. See `architect-review/`.

**Done**: the skill (`architect-review/SKILL.md`), the output format
(`architect-review/references/format.md`), and two personas
(`architect-review/references/personas/the-pragmatic-modulith-architect.md`,
`architect-review/references/personas/the-assembler.md`). Adding a new persona means
adding a new file to `references/personas/`; nothing else in the skill needs to change.

The Pragmatic Modulith Architect is deliberately unnamed as an individual, even though it
started as a description of a real person's approach; a persona's technical opinions
shouldn't be publicly attributed to a real, named colleague without their consent.

**Done, this session**: each persona now produces its own separate output (never merged),
`format.md`'s worked example now shows both personas on the same input (the earlier gap
where only one persona was demonstrated is closed), and The Assembler's persona file now
covers cross-vendor observability explicitly (a specific failure mode: a PM approves a
buy-everything approach without anyone considering how the team will monitor several
disparate vendor systems together, and finds out the hard way when something breaks). An
opt-in debate format was also added: when two personas are compared, the user can ask for
a bounded debate between them (one challenge, one response, closing "take this approach
if..." decision rules), grounded in a short product-manager intake (budget sensitivity,
operational appetite, failure visibility, risk tolerance, timeline pressure) rather than a
generic philosophical argument. See `architect-review/SKILL.md` Step 7 and
`references/format.md`'s Debate Format section.

**Done, this session**: the debate feature ran live for the first time, in the DispatchIQ
test run (`test/output/2026-09-22-dispatchiq/06c-architect-debate.md`), grounded in a
simulated product-manager intake around the PR/FAQ's own named risk (SMS delivery failing
silently). Challenge and Response stayed specific to that risk rather than drifting into
restating each persona's opening position. Also retrofitted onto the earlier PlotShare run
(`test/output/2026-09-22-plotshare/06c-architect-debate.md`), which had been left as a
single combined file predating the per-persona-file convention; splitting it and adding a
debate surfaced a real gap neither standalone review had made explicit (neither said where
a failure alert should actually land for a team with no engineering headcount). The debate
output file naming convention is now fixed as `<fileid>-architect-debate.md` (e.g.
`06c-architect-debate.md`), documented in `test/README.md` and `architect-review/SKILL.md`.

**Open**:
- The Assembler is a first draft, built as a deliberate, good-faith counterweight to the
  other persona's philosophy rather than from examples. Refine it as cases (won or lost)
  of vendor-first architecture become available, the same way the first persona's file
  improved once grounded in transcripts.
- A third persona hasn't been discussed yet. No need to add one for its own sake; wait
  until a specific gap in coverage shows up (e.g. a security-first or compliance-first
  architect, if the two existing personas' shared blind spots turn out to matter for an
  initiative).

## Pipeline testing

**Status**: three end-to-end runs completed and kept in `test/output/`
(`2026-09-22-claude-skills-meta`, `2026-09-22-plotshare`, `2026-09-22-dispatchiq`), with a
documented convention in `test/README.md` for future runs (one folder per run,
`dialogue.md` plus numbered artifacts, lettered files per use case or persona when there's
more than one, product ideas generated per run rather than fixed).

**Done, this session (DispatchIQ run)**: the first run through the for-profit branch of
`working-backwards-prfaq`'s Internal FAQ (TAM, unit economics, path to a revenue target),
which the two earlier runs never exercised since both were non-commercial initiatives.
Bracket-placeholder discipline held throughout (`[TAM_ESTIMATE]`, `[UNIT_ECONOMICS_DETAIL]`,
`[PRICING_DETAIL]` flagged rather than invented). Two more use-case-uml self-check bugs
caught and fixed during authoring: an actor listed but never used in the Basic Path, and an
Exception Path that said "Use case continues at Basic Path #N" while contradicting its own
prior step (logged a notification as failed, then rejoined at the step that logs it as
sent). See the run's own findings for detail.

**Found and fixed, this session**: clean-style was skipped entirely while drafting the
DispatchIQ artifacts (the PR/FAQ and both architect reviews), unlike every other file this
session, which had at least a grep-based self-check. Caught by the user flagging two
specific lines, one filler-word violation and one contrastive "not X" construction that the
grep-based check wouldn't have caught anyway, since it only searched for specific banned
words, never the contrastive-construction pattern. Root cause: skills that produce
external-facing prose (`working-backwards-prfaq` especially) had their own copy of
generic slop-prevention rules, written before `clean-style` existed as a separate skill and
never updated as `clean-style`'s own rule set grew (it gained the "real" filler rule and the
"Every/All/Each opener" rule after `working-backwards-prfaq`'s copy was written). Fixed by
removing the duplicated rules from `working-backwards-prfaq/SKILL.md` (keeping only its
PR/FAQ-structural rules) and adding an explicit "check whether clean-style is available,
read its `references/rules.md`, self-check against it" instruction to
`working-backwards-prfaq`, `architect-review`, `use-case-uml`, `use-case-discovery`, and
`use-case-requirements`, so there's one source of truth instead of copies that drift.

**Open**:
- None of the three runs test "offer the next step" or the unavailable-skill fallback. All
  three were driven by an operator (me) who already knew the pipeline sequence and invoked
  each skill directly, so none tested whether a skill spontaneously surfaces its handoff,
  or what happens when the offered skill isn't installed. Every skill's `SKILL.md` now
  includes an availability check on its handoff offer (added this session); a future run
  needs to start from a colder conversation, without the sequence already known, to test
  this.
- Skill discoverability via the harness's synced `.claude/skills/` was inconsistent across
  this session: the available-skills list fluctuated between showing all seven skills and
  showing as few as one or three, with no action taken on this repo's side. Not something
  this repo controls, but worth knowing if a future test run reports a skill as
  "unavailable" that should exist: distinguish a true gap from this same sync flakiness
  before treating it as a bug.
- `working-backwards-prfaq` now offers to hand off to `use-case-discovery` at the end of
  Step 3 (added this session, closing a gap the first test run's own Internal FAQ risk
  section named). Not yet verified in a live run.
- Both runs originally drafted only one use case per initiative, which isn't realistic;
  most projects have several. Fixed in the PlotShare run by drafting three use cases as
  separate, cross-linked files (`test/output/2026-09-22-plotshare/03a-list-surplus-produce.md`,
  `03b-claim-surplus-listing.md`, `03c-route-unclaimed-surplus-to-food-bank.md`). The meta
  run (`2026-09-22-claude-skills-meta`) still only has one; worth extending the same way if
  that run gets revisited.
- Even in the PlotShare run's three-use-case set, the downstream artifacts (test cases,
  requirements, architect review) still only cover the one use case drafted first. Testing
  multi-use-case coverage means running those across the full set, not just one member of
  it.
- Possible use-case-uml spec gap, found while drafting the third PlotShare use case: its
  self-check requires every listed Actor to appear in the Basic Path specifically. An
  actor that only appears in an Exception Path (e.g. an escalation contact, reached only
  on failure) is a normal pattern but currently fails that check. Worth deciding whether
  the rule should allow an Actor to be used anywhere in the document, not just the Basic
  Path, before this comes up again.
