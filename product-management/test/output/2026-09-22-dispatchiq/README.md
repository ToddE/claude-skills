# Pipeline test run: DispatchIQ, 2026-09-22

A third end-to-end run, this time with a product idea generated for the test itself
(DispatchIQ, an auto-routing dispatch and customer-notification tool for small home-service
businesses), chosen specifically to exercise the for-profit branch of
`working-backwards-prfaq`'s Internal FAQ and the `architect-review` debate feature, neither
of which the first two runs (a non-commercial meta announcement, and PlotShare, a city
department program) touched.

## Findings

- **The for-profit branch holds up.** TAM, unit economics, and a path to a revenue target
  all came out of the Internal FAQ with bracket placeholders (`[TAM_ESTIMATE]`,
  `[UNIT_ECONOMICS_DETAIL]`, `[PRICING_DETAIL]`) instead of invented numbers, the same
  discipline the non-commercial runs showed for their own success metrics.
- **Two more use-case-uml self-check bugs, caught and fixed during authoring**: an actor
  (`Technician`) initially listed but never used in the Basic Path, and an Exception Path
  that said "Use case continues at Basic Path #N" while contradicting its own prior step
  (it had just logged a notification as failed, then the rejoin pointed at the step that
  logs it as sent). Fixed by giving the Technician a real Basic Path step and changing the
  exception to "End of use case" instead of a false rejoin.
- **The debate feature ran live for the first time** (`06c-architect-debate.md`), grounded
  in a simulated product-manager intake built around the PR/FAQ's own named risk (SMS
  delivery failing silently). Challenge and Response stayed specific to that risk instead
  of drifting into restating each persona's opening position.
- **Clean-style was skipped entirely during authoring**, caught by the user flagging two
  specific lines in the PR/FAQ: a "real" filler-word violation, and separately a
  contrastive "not X" construction that a filler-word grep wouldn't have caught anyway.
  Root cause and fix are recorded in `TODO.md` under Architect Review/Pipeline testing:
  `working-backwards-prfaq` had its own stale, duplicated copy of clean-style's rules,
  written before clean-style existed as a separate skill. Fixed by removing the duplicate
  and having five skills defer to clean-style directly instead.
- **Requirements output was under-decomposed**, the same finding as PlotShare's run:
  `05a`/`05b` originally had three requirements each, collapsing distinct effects
  (calculate, decide, persist, notify) into one requirement per path. Regenerated at the
  corrected granularity (six requirements in `05a`, five in `05b`) after fixing
  `use-case-requirements`'s grouping rule; see `TODO.md` for the full fix.

## Files

- `dialogue.md`: the intake conversation across every skill used in this run, including
  the debate's product-manager intake.
- `01-prfaq.md`, `02-use-case-candidates.md`: PR/FAQ and candidate use case list.
- `03a-auto-route-a-new-job.md`, `03b-notify-customer-of-technician-eta.md`: two use cases,
  cross-linked and actor-consistent.
- `04a-test-cases-auto-route.md`, `04b-test-cases-notify-eta.md`: test cases per use case.
- `05a-requirements-auto-route.md`, `05b-requirements-notify-eta.md`: functional
  requirements per use case, regenerated at the corrected granularity (see Findings above).
- `06a-pragmatic-modulith-architect.md`, `06b-assembler.md`, `06c-architect-debate.md`:
  the two persona recommendations and the debate between them.
