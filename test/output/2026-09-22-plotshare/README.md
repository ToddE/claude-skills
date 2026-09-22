# Pipeline test run: PlotShare, 2026-09-22

A second end-to-end run, this time with a product idea generated for the test itself
(PlotShare, a community-garden plot scheduler and surplus-produce router run by a city
parks department), chosen specifically to exercise `working-backwards-prfaq`'s new
non-commercial framing added earlier this session.

## Findings

- **The non-commercial generalization works.** The Internal FAQ correctly reframed
  "success" around adoption and community outcomes (70% active usage, 200 lbs of surplus
  routed, fewer scheduling disputes) instead of forcing TAM or profitability language onto
  a city-department program. This was the specific gap the first test run (`../
  2026-09-22-claude-skills-meta/`) found; it's fixed.
- **Authoring bug caught and fixed mid-run**: the use case initially gave its Alternate
  and Exception paths their own terminal Post-Conditions, even though both paths rejoin
  the Basic Path rather than ending the use case. Per use-case-uml's own spec, only
  *terminal* exit points get their own Post-Condition. Caught during the test, fixed in
  both the use case and the test cases that depended on it (`04-test-cases.md`), which
  correctly needed rejoin-point expected results instead of a Post-Condition reference.
  Worth double-checking this distinction (terminal vs. rejoining paths) explicitly in
  future use-case-uml runs.
- **This run only drafted one use case at first, which is unrealistic.** Flagged directly:
  real projects have more than one use case, and the single use case drafted first
  ("Claim a Surplus Listing") already referenced a second one that didn't exist yet, a
  dangling cross-link. Fixed by drafting the two use cases it actually depends on ("List
  Surplus Produce," "Route Unclaimed Surplus to Food Bank"), each its own file
  (`03a-list-surplus-produce.md`, `03b-claim-surplus-listing.md`,
  `03c-route-unclaimed-surplus-to-food-bank.md`), cross-linked by path. This is what
  actually exercises use-case-uml's actor-consistency rule across a set of use cases; one
  use case in isolation can't test that at all.
- **Possible spec gap found while adding the third use case**: "Route Unclaimed Surplus to
  Food Bank" initially listed a `Garden Coordinator` actor that only appeared in its
  Exception Path, never the Basic Path. use-case-uml's self-check requires every listed
  Actor to appear in the Basic Path specifically, so this failed the check even though an
  actor that only shows up during a failure path (an escalation contact, for example) is a
  completely normal real-world pattern. Fixed here by dropping the named actor and
  describing the escalation without one, but that's a workaround, not a resolution. Worth
  deciding whether use-case-uml's rule should allow an Actor to be used anywhere in the
  document (Basic Path or Alternate/Exception Paths) rather than requiring Basic Path
  presence specifically.
- **`04-test-cases.md` and `05-requirements.md` still only cover "Claim a Surplus
  Listing,"** even though the use case set grew to three. Extending them to cover all three
  wasn't done in this run; noted as open in `TODO.md` rather than done here, since the
  finding worth capturing was the use-case-authoring gap, not a full redo of every
  downstream artifact.
- **Architect review split into per-persona files, added after the fact.** This run
  originally produced a single combined `06-architect-review.md`, before the skill and its
  format spec moved to one file per persona plus an opt-in debate. Retrofitted here to
  `06a-pragmatic-modulith-architect.md`, `06b-assembler.md`, and `06c-architect-debate.md` so this run
  matches the current convention, with a debate grounded in PlotShare's own constraints
  (permanent near-zero budget, no engineering headcount after launch, zero failure
  visibility on the food bank notification today). The debate surfaced a point neither
  standalone review made explicit: whichever stack ships, the failure alert has to land
  somewhere department staff already check. Neither persona's original write-up said where
  the alert should go.
- **"Offer the next step" and the unavailable-skill fallback are not verified by this
  run.** This run was driven the same way as the first: I already knew the pipeline
  sequence and invoked each stage directly, so it doesn't test whether a skill
  spontaneously offers its handoff unprompted, or what happens when an offered skill isn't
  installed. That behavior was just added to each skill's `SKILL.md` (offer + check
  availability + point to this repo if missing) and still needs its own dedicated test,
  ideally from a colder conversation that isn't already primed with the full sequence.

## Files

- `dialogue.md`: the intake conversation across the skills used in this run.
- `01-prfaq.md`, `02-use-case-candidates.md`: same shape as the first run.
- `03a-list-surplus-produce.md`, `03b-claim-surplus-listing.md`,
  `03c-route-unclaimed-surplus-to-food-bank.md`: three use cases (not just one), each its
  own file, cross-linked by path and actor-consistent across all three.
- `04-test-cases.md`, `05-requirements.md`, `06-architect-review.md`: still scoped to
  "Claim a Surplus Listing" only; see the multi-use-case gap noted above.
