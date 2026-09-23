# Pipeline test run: Ebisu Kaiten-Zushi / Kaiten IQ, 2026-09-22

A sixth run, reusing real existing worked content instead of inventing everything from
scratch, and the first in a physical-retail/food-service domain built around real-time RFID
at high plate volume. Prior runs covered a non-commercial meta announcement, a
city-department program, a for-profit home-service SaaS, an education-sector cold run, and
a capital-intensive chip-manufacturing run. None reused prior pipeline content as source
material for a new run, and none exercised a domain where the core system is a fleet of
physically remote, IoT-style devices inside small businesses with no IT staff of their own.

The idea: Ebisu Kaiten-Zushi, an 18-location kaiten-zushi (conveyor-belt sushi) chain,
licenses Kaiten IQ, an RFID plate-tracking platform, to other conveyor-belt restaurant
operators. `03a-chef-input-commissioning.md` reuses the `use-case-uml/references/format.md`
worked example's actual "Chef Input (Commissioning)" content almost verbatim, per this run's
instructions: RFID plate commissioning, Live Inventory, and the "born on" timestamp are all
carried over unchanged, with only the generic "System" actor renamed to "Kaiten IQ" for
actor-name consistency with the two newly written use cases. `03b-automatic-freshness-pull`
and `03c-checkout-plate-tally` are new: freshness enforcement (plates pulled once they
exceed their category's freshness window) and checkout billing (a guest's plates tallied by
color/price tier), the two extensions the task suggested and both were written given the
time available.

## Environment finding: confirmed, not new

Before drafting anything, this run called the real `Skill` tool for `working-backwards-prfaq`
directly, the same as every prior non-cold run. It silently loaded an unrelated, generic
skill from a different plugin (`anthropic-skills`), not this repo's own
`product-management/skills/working-backwards-prfaq`, confirmed by diffing the loaded
instructions against this repo's actual file. This exactly matches what
`2026-09-22-classpods-cold-run/README.md` first documented and `2026-09-22-continental-
circuits/dialogue.md` confirmed again: the `product-management` plugin isn't installed in
this session, and a same-named skill from another plugin silently answers instead of
erroring. This run does not re-report it as a new finding.

Given that, this run read each of the six skills' current `SKILL.md` and `references/*.md`
files directly from this repo and executed that documented procedure by hand, stage by
stage, self-answering as Ebisu Kaiten-Zushi's founder, the same workaround every prior
non-cold run used. `clean-style` genuinely is installed as a project-scoped skill in this
session (its base directory resolved to this repo's own `.claude/skills/clean-style`, not a
colliding one), and was invoked for real through the `Skill` tool for the PR/FAQ self-check.

## A genuine skill-level bug found and fixed (not just this run's content)

Running `use-case-uml`'s own Step 3 self-check for real against `03b`'s two Exception Paths
surfaced a real inconsistency in the skill's own files, not a defect in this run's use
cases. `03b`'s "flagged plate is gone from the belt before Floor Staff retrieves it"
Exception Path genuinely terminates (that specific plate's lifecycle is over; it doesn't
rejoin the Basic Path the way a retry or correction would), so it needed to end with
something other than "Use case continues at Basic Path #N." Checking what the skill's own
spec actually allows turned up the bug:

- `use-case-uml/references/format.md`'s prose rule stated only one ending for Alternate and
  Exception Paths: `Use case continues at Basic Path #<N>.` (plus `TBD` for unresolved
  failure modes). But that same file's own worked example, "Client Update on First
  Launch," ends its Exception Path A with `7. End of use case.`, a third pattern the
  written rule never sanctioned or even mentioned.
- `use-case-uml/SKILL.md`'s Step 2 spec (bullet 6-7) and Step 3 self-check checklist
  repeated the same gap: the self-check literally told an author to verify every
  Alternate/Exception Path "ends with 'Use case continues at Basic Path #N.' (or `TBD` if
  not yet resolved)", with no mention of a legitimate terminal exit. Anyone following that
  checklist literally would either force an artificial "continues at" loop-back onto a
  genuinely terminal path, or not know that file's own worked example's phrasing was
  sanctioned at all.

**Fixed in the skill itself**, not just this run's output:
- `product-management/skills/use-case-uml/references/format.md`: the Alternate Paths and
  Exception Paths rules now state both valid endings (rejoin or terminal exit), pointing to
  the existing "Client Update on First Launch" worked example as the terminal-exit
  precedent.
- `product-management/skills/use-case-uml/SKILL.md`: Step 2's bullets 6-7 and the Step 3
  self-check checklist now list "End of use case." alongside "Use case continues at Basic
  Path #N." and `TBD` as the three valid endings.

With that fix in hand, `03b`'s Exception Path A (uncollected plate) correctly ends with
"End of use case," and this run's `dialogue.md` records the self-check that found it.

## Other findings

- **The reused Chef Input use case held up under actor-renaming.** Renaming the worked
  example's generic "System" actor to "Kaiten IQ" (for consistency with the two new use
  cases' actors) required no other change to the Basic Path, Exception Paths, or
  Post-Condition; the content was sound as written, which is itself a small piece of
  evidence that the format reference's worked examples are usable as real use-case content,
  not just illustrative prose.
- **No actor-consistency bug found in this run's own drafting**, unlike `continental-
  circuits`, which found and fixed a real "actor used only in Exception Paths" violation.
  Worth stating plainly rather than manufacturing a finding: every actor in `03a`, `03b`,
  and `03c` (Chef, Kaiten IQ, Floor Staff, Guest, Cashier) appears in its Basic Path, and
  all three documents use identical actor names throughout. This run's self-check passed
  cleanly here; the bug it did find was in the skill file, not the content.
- **The granularity self-check caught real "and"-joined-effects patterns and split them**,
  the same category `continental-circuits` and `dispatchiq` each documented finding in
  their own runs. `05b`'s Exception Path A (a flagged plate reported uncollected) splits
  the record-marking effect from the manager-review-logging effect into
  `REQ-FreshnessPull-08` and `-09`, since one can fail (the removal doesn't get marked)
  independently of the other (the marking succeeds but the discrepancy never reaches a
  manager's queue). `05a` and `05c` each made a similar split on their own Basic Path steps
  that combined detection and lookup/association into one sentence.
- **The granularity self-check also caught a case for explicitly declining a requirement**,
  a pattern not yet documented in a prior run's README: `05c`'s Basic Path step 8 (Cashier
  processes payment) got no Kaiten IQ requirement, since payment processing itself is
  explicitly out of scope for this initiative per `02-use-case-candidates.md`'s own scope
  note. Writing a requirement there would have violated the same "don't invent" discipline
  the skill's rule protects, just in the direction of tracking something the use case's own
  scope excludes rather than inventing something it never stated.
- **Clean-style's real self-check found one issue**, via the actual `Skill` tool since
  `clean-style` is genuinely installed in this session: "kaiten-zushi" appeared in the press
  release's dateline paragraph before a reader unfamiliar with the term would know what it
  means, even though the headline already glossed it. Fixed with an inline parenthetical
  gloss on first full-sentence use. The known passive-placeholder pattern
  (`continental-circuits` and `dispatchiq` both flagged "[X] to be finalized before general
  availability") and the known broad-quantifier-opener pattern were both avoided from the
  first draft rather than caught and fixed afterward, since this run's drafting was done
  with those two specific, previously-documented findings already in mind.

## Files

- `dialogue.md`: the full intake conversation across every skill used in this run, including
  the pre-intake namespace-collision check, the real `clean-style` invocation and its one
  finding, and the debate's product-manager intake.
- `01-prfaq.md`, `02-use-case-candidates.md`: PR/FAQ and candidate use case list.
- `03a-chef-input-commissioning.md`: reused, with substance unchanged, from
  `use-case-uml/references/format.md`'s own worked example.
- `03b-automatic-freshness-pull.md`, `03c-checkout-plate-tally.md`: two newly drafted use
  cases, cross-linked with `03a` and with each other, and actor-consistent (Kaiten IQ
  appears in all three; Floor Staff and Cashier are shared, distinct roles).
- `04a`/`04b`/`04c`: test cases per use case, one per Basic/Alternate/Exception Path.
- `05a`/`05b`/`05c`: functional requirements per use case, decomposed on distinct
  effects/components per the granularity self-check (see Findings above), with CSV export.
- `06a-pragmatic-modulith-architect.md`, `06b-assembler.md`, `06c-architect-debate.md`: both
  personas' recommendations, scoped to the software and edge-connectivity system behind
  commissioning, freshness monitoring, and checkout (not belt hardware manufacturing or tag
  sourcing), and the debate between them, grounded in a licensing-business-specific
  product-manager intake (structural budget tightness, a two-engineer team, and a "silent
  failure at a restaurant we don't staff" failure-visibility fear neither generic persona
  description would have surfaced on its own).

## What's still open

- Whether this repo's actual six skills' spontaneous handoff offers and clean-style
  deferral work as written when dispatched through the real `Skill` tool remains untested by
  this run, for the same root-cause reason `classpods-cold-run` already documents. Needs a
  run in a session with `product-management` actually installed and no colliding skill name.
- `[MAX_READ_INTERVAL]`, `[SCALE_TARGET]`, `[DISCOUNT_POLICY]`, and the RFID antenna
  hardware vendor (flagged across `05b`, `05c`, and both architect recommendations) are
  genuine open gaps carried through the pipeline, not invented answers.
- Whether Kaiten IQ should detect a previously-flagged plate before it reaches a guest's
  table, rather than only at checkout (`03b` and `03c`'s Open Issues/Notes both raise this),
  is unresolved and would change `03c`'s Exception Path B if answered differently.
