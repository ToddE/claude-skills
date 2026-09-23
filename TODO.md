# TODO

Planned work for this repo.

## Architect Review skill

**Status**: two personas shipped (The Pragmatic Modulith Architect, The Assembler). The
multi-persona pattern this skill was built for is now validated: two different
philosophies, applied to the same input, produce different recommendations rather than the
same advice in a different tone. See `product-management/skills/architect-review/`.

**Done**: the skill (`product-management/skills/architect-review/SKILL.md`), the output format
(`product-management/skills/architect-review/references/format.md`), and two personas
(`product-management/skills/architect-review/references/personas/the-pragmatic-modulith-architect.md`,
`product-management/skills/architect-review/references/personas/the-assembler.md`). Adding a new persona means
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
generic philosophical argument. See `product-management/skills/architect-review/SKILL.md` Step 7 and
`references/format.md`'s Debate Format section.

**Done, this session**: the debate feature ran live for the first time, in the DispatchIQ
test run (`product-management/test/output/2026-09-22-dispatchiq/06c-architect-debate.md`), grounded in a
simulated product-manager intake around the PR/FAQ's own named risk (SMS delivery failing
silently). Challenge and Response stayed specific to that risk rather than drifting into
restating each persona's opening position. Also retrofitted onto the earlier PlotShare run
(`product-management/test/output/2026-09-22-plotshare/06c-architect-debate.md`), which had been left as a
single combined file predating the per-persona-file convention; splitting it and adding a
debate surfaced a real gap neither standalone review had made explicit (neither said where
a failure alert should actually land for a team with no engineering headcount). The debate
output file naming convention is now fixed as `<fileid>-architect-debate.md` (e.g.
`06c-architect-debate.md`), documented in `product-management/test/README.md` and `product-management/skills/architect-review/SKILL.md`.

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

**Done, this session**: `examples.html` plays back a run's `dialogue.md` turn by turn (a
small client-side parser reads the `**Claude:**`/`**User (simulated):**`/`## section`
convention every run already follows), with play/pause, a 1x/2x/4x speed control, and a
"skip to results" button that jumps straight to a curated list of that run's artifacts on
GitHub. No backend: everything fetches straight from this public repo via
raw.githubusercontent.com, so it works on GitHub Pages as static hosting with no API key or
server. Linked from `index.html` and `product-management/README.md`. Adding a new run to
the picker is one entry in the `EXAMPLES` array (see the comment above it in
`examples.html`); `product-management/test/GENERATE-EXAMPLE.md`'s last step says to do this
whenever a new run is meant for the gallery.

**Open**:
- The `2026-09-22-claude-skills-meta` run has no `dialogue.md` (see the known gap in
  `product-management/test/README.md`), so its gallery entry has `hasDialogue: false` and
  jumps straight to results. Worth writing a `dialogue.md` for it retroactively if that run
  ever gets revisited, so all gallery entries can play back.
- Not tested on an actual deployed GitHub Pages URL yet, only reasoned through locally
  (parser tested against real `dialogue.md` files via Node, not in a browser). Worth a real
  smoke test once pushed: confirm the `raw.githubusercontent.com` fetch works from the
  Pages origin (it should, no CORS issue expected for a public repo, but unverified).

## Pipeline testing

**Status**: six end-to-end runs completed and kept in `product-management/test/output/`
(`2026-09-22-claude-skills-meta`, `2026-09-22-plotshare`, `2026-09-22-dispatchiq`,
`2026-09-22-classpods-cold-run`, `2026-09-22-continental-circuits`,
`2026-09-22-ebisu-kikata`), with a documented convention in
`product-management/test/README.md` for future runs (one folder per run, `dialogue.md`
plus numbered artifacts, lettered files per use case or persona when there's more than one,
product ideas generated per run rather than fixed) and a repeatable process for generating
a new one in `product-management/test/GENERATE-EXAMPLE.md`. Four of the six are in the
GitHub Pages examples player (`examples.html`); see that section below.

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
removing the duplicated rules from `product-management/skills/working-backwards-prfaq/SKILL.md` (keeping only its
PR/FAQ-structural rules) and adding an explicit "check whether clean-style is available,
read its `references/rules.md`, self-check against it" instruction to
`working-backwards-prfaq`, `architect-review`, `use-case-uml`, `use-case-discovery`, and
`use-case-requirements`, so there's one source of truth instead of copies that drift.

**Found and fixed, this session**: requirements output across all three runs was under-
decomposed, collapsing several distinct system behaviors (calculate, decide, persist,
notify) into one requirement per Basic Path, sometimes spanning two different owning
components in a single requirement. Traced to `use-case-requirements`'s own grouping
guidance ("group naturally related steps") being too loose; even the skill's own worked
example in `references/format.md` did this (one requirement bundled the client asking for
an update with the platform deciding to require one). Fixed by replacing the vague
guidance with a concrete test (does this step have its own independently nameable failure
mode?) and two patterns that follow from it (different Component is a strong split signal
except for one atomic multi-component handoff; same Component splits on distinct effects).
Regenerated `05a`/`05b` in the DispatchIQ run and `05-requirements.md` in the PlotShare run
at the corrected granularity, and rewrote the worked example in
`product-management/skills/use-case-requirements/references/format.md` to demonstrate it.

**Done, this session (cold run)**: ran a genuinely cold test —
`product-management/test/output/2026-09-22-classpods-cold-run/` — where the operator only
invoked `working-backwards-prfaq` by name and let each subsequent skill's own offer (or
lack of one) drive what happened next, instead of invoking every stage directly the way the
first three runs did. It found something bigger than the offer/fallback question it set out
to test: calling the bare skill name (`Skill(skill: "working-backwards-prfaq")`) silently
ran a different skill of the same name (a personal custom skill synced to that account,
unrelated to this repo, not an Anthropic-published one, confirmed via
`~/.claude/skills/synced/.../manifest.json`'s `"source": "custom"` tag) instead of this
repo's version, with no error or indication of the mismatch. The fully-qualified name
(`product-management:working-backwards-prfaq`) does resolve correctly and fails cleanly
with `Unknown skill` when not installed, but nothing prompts a user toward it. Net effect:
the handoff-and-fallback logic in every `SKILL.md` here is untestable, and unusable, in any
session where a same-named skill from another source already exists, because the wrong one
answers before this repo's logic ever runs. Documented in
`product-management/README.md`'s Install section (use the qualified name if you have a
same-named skill elsewhere) rather than renaming the skill, since "Working Backwards
PR/FAQ" is also the recognizable term from Amazon's own methodology.

**Done, this session (Continental Circuits run)**: a fifth run in a genuinely new
domain — physical manufacturing (a U.S. factory building a security gateway from only
U.S./EU-made chips), exercising capital expenditure, supply-chain lead times, and
export-control/sourcing compliance, none of which any software-only run touched.
Re-confirmed the naming-collision finding above independently (hit the same collision,
worked around it by running each skill's actual current file by hand) without finding any
new skill-level bugs; its self-checks caught only content issues in its own output
(an actor-consistency fix in `03b`, a requirement-granularity split in
`05b-requirements-allocate-inventory.md`), both working exactly as the fixes earlier in this
document intended.

**Found and fixed, this session (Ebisu Kaiten IQ run)**: a sixth run, the first to reuse
real prior content instead of drafting everything new — `03a-chef-input-commissioning.md`
carries over `use-case-uml/references/format.md`'s own "Chef Input (Commissioning)" worked
example almost verbatim (only the generic "System" actor renamed for consistency), plus two
newly written use cases (freshness enforcement, checkout tally) in a physical-retail RFID
domain no prior run touched. Running the skill's own self-check for real surfaced a genuine
spec bug: `use-case-uml/references/format.md`'s prose rule for Alternate/Exception Paths
named only one valid ending ("Use case continues at Basic Path #N.", plus `TBD`), but that
same file's own worked example ("Client Update on First Launch") ends an Exception Path
with "End of use case.", a third pattern the written rule never sanctioned.
`use-case-uml/SKILL.md`'s Step 2 spec and Step 3 self-check checklist repeated the same
gap. Fixed both files to explicitly list "End of use case." as a valid terminal ending
alongside the rejoin and `TBD` cases, citing the existing worked example as precedent, so
future authoring can end a genuinely terminal Alternate/Exception Path correctly instead of
forcing an artificial rejoin. Also confirmed the granularity self-check catching an
"and"-joined-effects split in `05b`, and a first-of-its-kind case for explicitly declining a
requirement (payment processing, out of scope per the use case candidates' own scope note).

**Done, this session (standalone-mode verification)**:
`product-management/test/output/2026-09-23-standalone-mode/` closes a gap the classpods
cold run's finding left open: every one of the six pipeline example runs chains
`working-backwards-prfaq` into all five downstream skills, so each downstream skill's
"don't re-ask if already given" rule always fires and its own real interview never runs in
any existing transcript, even though every one of those five `SKILL.md` files documents
standalone, cold-invocation behavior. This run invoked each of the five downstream skills
in isolation, with five unrelated one-off scenarios and zero shared context between them,
and confirmed by hand (the real `Skill` tool returned `Unknown skill` for all five in that
session, a more complete gap than the `working-backwards-prfaq` collision, so each skill's
current file was read and executed manually per the same workaround prior runs used): all
five worked exactly as documented, including use-case-discovery's own handoff-offer and
unavailable-skill disclosure, and architect-review's Step 1 one-line-idea handling and
opt-in-only debate. One genuine, minor spec bug found and fixed: `use-case-uml/SKILL.md`'s
Step 3 self-check allowed `TBD` as a valid Alternate Path ending, which
`references/format.md` only ever sanctioned for Exception Paths (Alternate Paths are known
valid variations, not unresolved failure modes); corrected in place.

**Open**:
- The finding above proves each skill's own standalone entry point works, but not the
  live, chained handoff sequence between them (discovery &rarr; uml &rarr; test-cases/
  requirements &rarr; architect-review actually run back-to-back in one session). That,
  and the unavailable-skill fallback specifically, remain untested end-to-end — the
  classpods cold run never got past step one with this repo's actual code running, because
  `working-backwards-prfaq` collided with an unrelated same-named skill before the chain
  could start. A follow-up run needs the `product-management` plugin actually installed (or
  every skill invoked by fully-qualified name) to exercise the real chain.
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
  separate, cross-linked files (`product-management/test/output/2026-09-22-plotshare/03a-list-surplus-produce.md`,
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
