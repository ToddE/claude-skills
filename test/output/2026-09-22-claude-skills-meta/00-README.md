# Pipeline test run: 2026-09-22

A live, end-to-end run of all six pipeline skills, announcing this repo as the test
subject. Each numbered file is the real output of one skill, in sequence: PR/FAQ, use case
candidates, one full use case, test cases, requirements, and an architecture review with
both personas.

This is QA evidence, not published documentation. Kept in the repo as requested rather
than in a temp directory, so it's inspectable. `.claude/skills/` (the local install used to
run this test) is gitignored; these output files are not.

## Findings

- **All six skills ran correctly end to end.** Each one's self-check criteria held up:
  format compliance in the PR/FAQ (395 words, no em-dashes, no banned hyperbole), correct
  actor/step handling and section omission (no Trigger(s) section, since the use case
  continues from Use Case Discovery) in the use case, correct rejoin-point handling
  (Alternate/Exception path test cases described state at rejoin, not the eventual Basic
  Path outcome) in the test cases, no silently-guessed Priority in the requirements, and
  two genuinely different, traceable recommendations (not the same advice in a different
  voice) from the two architect personas on the same input.
- **Gap**: Working Backwards PR/FAQ's Internal FAQ template assumes a commercial, revenue-
  generating product (TAM, unit economics, path to profitability). It doesn't branch for a
  free or open-source announcement. Had to reframe those questions around adoption instead
  of revenue. Worth a note in that skill's `SKILL.md`, not an urgent fix.
- **Minor**: skill discovery through the harness was inconsistent across invocations, one
  resolved through a "synced" copy under `~/.claude/skills/synced/...`, later ones
  resolved straight to the project symlink. Not a bug in any skill's own content; a
  harness-level discovery detail worth being aware of, not something this repo controls.
- **Observation, not a bug**: Use Case Discovery correctly flagged that one of its own
  candidates ("Apply Clean Style to External Writing") doesn't chain from the others and
  asked whether it belongs in the initiative at all. That's the skill doing its job, not a
  defect.

## Files

1. `01-prfaq.md` — Working Backwards PR/FAQ, announcing Claude Skills itself.
2. `02-use-case-candidates.md` — Use Case Discovery's candidate list, derived from the PR/FAQ.
3. `03-use-case-draft-full-use-case.md` — Use Case UML, one candidate written in full.
4. `04-test-cases.md` — Use Case Test Cases, derived from file 3.
5. `05-requirements.md` — Use Case Requirements (Mode A), derived from file 3.
6. `06-architect-review.md` — Architect Review, both personas, grounded in files 1, 3, and 5.
