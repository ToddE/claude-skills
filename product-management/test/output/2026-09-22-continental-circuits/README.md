# Pipeline test run: Continental Circuits, 2026-09-22

A fifth run, and the first in a capital-intensive, physical-manufacturing domain instead of
software: Continental Circuits, a new U.S. manufacturer opening a factory in Zanesville,
Ohio to build the Trustpoint Hub, a Matter-compatible security gateway built only on U.S.-
and EU-fabricated chips, positioned around supply-chain resilience for customers already
restricted from certain foreign-made networking gear (NDAA Section 889, the FCC Covered
List). Chosen specifically to exercise capital expenditure, long chip-supplier lead times,
physical inventory allocation, and export-control/sourcing compliance, none of which the
four prior runs (a non-commercial meta announcement, a city-department program, a
for-profit home-service SaaS, and an education-sector cold run) touched.

## Environment finding: confirmed, not new

Before drafting anything, this run tried the real `Skill` tool for `working-backwards-prfaq`
the same way the non-cold runs before it did. `Skill(skill: "working-backwards-prfaq")`
silently loaded an unrelated, generic skill from a different plugin (`anthropic-skills`),
not this repo's own `product-management/skills/working-backwards-prfaq`, confirmed by
diffing the two files directly. `Skill(skill: "product-management:working-backwards-prfaq")`
returned a clean `Unknown skill`. Both outcomes exactly match what
`2026-09-22-classpods-cold-run/README.md` already documented in detail: this repo's
`product-management` plugin is not installed in this Claude Code session (or, it appears,
in any session these test runs have been executed in), and a same-named skill from another
plugin silently answers instead of erroring.

**This run does not re-report this as a new finding.** It confirms the prior run's finding
still holds, and, like the prior non-cold runs (`dispatchiq`, `plotshare`, the meta run),
worked around it the same way: reading each of the six skills' current `SKILL.md` and
`references/*.md` files directly from this repo and executing that documented procedure by
hand, stage by stage, rather than dispatching through the (unavailable) `Skill` tool. This
means, like every run before the cold run, this run does not independently verify that the
real `Skill`-tool dispatch path (spontaneous handoffs, the unavailable-skill fallback
language) works end to end; only the cold run's own README speaks to that, and only
partially, since the collision prevented it from getting past step one there too. This
remains open until a run happens in a session where `product-management` is actually
installed with no colliding skill name present.

`clean-style` genuinely is installed in this session, unlike the six `product-management`
skills, and was invoked for real through the `Skill` tool (see `dialogue.md`) to self-check
the drafted PR/FAQ. That part of this run is a real Skill-tool invocation, not a manual
simulation.

## Findings

- **The manufacturing/hardware flavor came through where it should.** The PR/FAQ's Internal
  FAQ covers factory capex, chip-supplier qualification lead times (26-52 weeks), and
  allocation-constrained chip supply as the top named risk, with no cloud-hosting or SaaS
  unit-economics language anywhere, unlike `dispatchiq`'s TAM/SMS-cost framing or
  `classpods`'s FERPA framing. Architect Review explicitly scoped itself to the software
  system behind supplier qualification and chip allocation, not the physical assembly line,
  since neither persona file has anything to say about manufacturing-line tooling and
  inventing an opinion there would have violated the skill's own instruction not to invent
  constraints a persona's file doesn't support. See `06a`/`06b`'s "Scope note."
- **A genuine use-case-uml self-check catch, found and fixed during authoring**: the first
  draft of `03b-allocate-chipset-inventory-to-a-production-run.md` listed "Sourcing Manager"
  as an Actor that appeared only in Exception Paths, never in the Basic Path itself,
  violating the skill's own Step 3 rule that every listed Actor must appear at least once in
  the Basic Path. Same category of bug `dispatchiq`'s README documents finding for its own
  unused "Technician" actor. Fixed by giving Sourcing Manager a real Basic Path step
  (acknowledging the confirmed allocation for supply-constrained chips on every run, not
  only during a shortage), reflecting real day-to-day Sourcing behavior in an
  allocation-constrained business rather than an artificial step added just to satisfy the
  checklist. This was a content fix to this run's output; the self-check step itself worked
  exactly as `use-case-uml/SKILL.md` describes it.
- **The granularity self-check caught the exact "and"-joined-effects pattern the rule
  describes, and it was fixed before presenting, not after.** `03b`'s Exception Path A
  describes Continental ERP flagging a shortage "and" notifying the Sourcing Manager in one
  sentence. Split into two requirements (REQ-AllocateChips-08, -09), the identical split
  `dispatchiq`'s own README documents for its own flag-and-notify pattern. Final requirement
  counts (8 for `05a`, 11 for `05b`) reflect real decomposition across each use case's two
  Alternate/Exception Paths, not padding to hit a number.
- **Clean-style's real self-check (via the actual `Skill` tool, since it's genuinely
  installed) found four issues in the PR/FAQ draft**: two sentences opening with the broad
  quantifier "Every" (a rule this run had read but still drafted past on the first pass),
  one undefined-on-first-use acronym (NDAA Section 889), and two passive-voice placeholder
  sentences. All four fixed; see `dialogue.md` for the exact before/after text. Notably, the
  passive-placeholder pattern ("[X] to be finalized before general availability") is the
  exact phrasing `dispatchiq`'s already-published `01-prfaq.md` uses verbatim in two places;
  not fixed there since editing a prior run's own artifacts is out of scope for this one,
  but worth a light pass if that run gets revisited.
- **No skill-file bug found this run.** Unlike `dispatchiq` and `plotshare`, which each
  found and fixed a real defect in a skill's own instructions (a stale duplicated
  clean-style checklist, an under-specified granularity rule), this run's self-checks
  surfaced only content issues in this run's own output, all fixed as described above. The
  `SKILL.md` and `references/*.md` files this run actually executed (as opposed to the
  environment's inability to dispatch them via the `Skill` tool, a separate, already-known
  issue) held up as written.

## Files

- `dialogue.md`: the full intake conversation across every skill used in this run, including
  the pre-intake namespace-collision check, the real `clean-style` invocation and its
  findings, and the debate's product-manager intake.
- `01-prfaq.md`, `02-use-case-candidates.md`: PR/FAQ and candidate use case list.
- `03a-qualify-a-new-chipset-supplier.md`, `03b-allocate-chipset-inventory-to-a-production-run.md`:
  two use cases, cross-linked and actor-consistent (Sourcing Manager and Continental ERP
  appear in both).
- `04a-test-cases-qualify-supplier.md`, `04b-test-cases-allocate-inventory.md`: test cases
  per use case.
- `05a-requirements-qualify-supplier.md`, `05b-requirements-allocate-inventory.md`:
  functional requirements per use case, decomposed on distinct effects/components per the
  granularity self-check (see Findings above).
- `06a-pragmatic-modulith-architect.md`, `06b-assembler.md`, `06c-architect-debate.md`: the
  two persona recommendations, explicitly scoped to the supporting software system rather
  than the physical factory line, and the debate between them, grounded in a
  manufacturing-specific product-manager intake (export-control document handling, physical
  team bandwidth, procurement-office detection latency).

## What's still open

- Whether this repo's actual `working-backwards-prfaq` (and the other five skills') Step 3
  handoff offers and clean-style deferral work as written when dispatched through the real
  `Skill` tool remains untested by this run, for the same root-cause reason
  `classpods-cold-run` already documents. Needs a run in a session with `product-management`
  actually installed and no colliding skill name.
- `[DOCUMENTATION_DEADLINE]` and the lot-tracking-scope question (`03b`'s Open Issues/Notes)
  are genuine open gaps carried through to the requirements, not invented answers.
