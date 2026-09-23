# Generating a new example run

This is the process behind every folder in `output/` (the meta run, PlotShare, DispatchIQ),
written down so it's repeatable instead of re-derived each time. Hand this file to an agent
(with write access to this repo) when you want a new example, whether for the GitHub Pages
gallery or just to stress-test a corner of the pipeline that existing runs don't cover.

## Before starting: pick what this run should stress

Existing runs already cover: a non-commercial meta announcement, a city-department program
(non-commercial, low budget), and a for-profit small-business tool. A new run is worth more
if it's genuinely different in domain, scale, or stakes, not just a different noun for the
same shape of idea. Also consider whether this run should test something no prior run has:

- **A cold run**: prior runs were driven by an operator who already knew the full pipeline
  sequence and invoked each skill directly. None have tested whether a skill spontaneously
  offers its handoff unprompted (per its own `SKILL.md`), or what happens when an offered
  skill isn't in the current session's available skills. A cold run only ever acts on what
  the current skill's own output offers, rather than jumping ahead.
- **A different regulatory/compliance flavor**: healthcare, education, financial, or other
  domains surface different bracket-placeholder needs (`[COMPLIANCE_REQUIREMENT]`, data
  retention, accessibility) that a generic small-business or city-program idea won't.
- **A different scale**: enterprise-only, single-user, or very high-volume ideas exercise
  different judgment calls in Architect Review than the small-team examples so far.

Pick a real idea within one of those angles rather than a generic placeholder. Specificity
is what makes these runs worth reading.

## Running it

1. **Invent the idea.** One or two sentences: what it is, who it's for, why now. Give it a
   real name.
2. **Working Backwards PR/FAQ.** Run its intake for real, self-answering every question as
   if you were the person with the idea. Specific, not generic: a vague answer here (e.g.
   "small businesses") produces a weak PR/FAQ and the run isn't worth publishing. Actually
   read `clean-style/references/rules.md` before drafting, per that skill's own
   instruction, rather than relying on memory.
3. **Use Case Discovery**, then **Use Case UML** for at least two use cases, cross-linked
   and actor-consistent, each its own lettered file (`03a-`, `03b-`, ...). One use case
   isn't realistic; most initiatives have several.

   A confirmed candidate and PR/FAQ excuse skipping the *interview*, not the *confirmation*.
   Per `use-case-uml/SKILL.md` Step 1, draft each use case's Basic Path, Alternate/Exception
   Paths, and Post-Condition(s) directly from that upstream context, but then present the
   draft and get a real answer, an actual back-and-forth in `dialogue.md`, before treating it
   as final. A PR/FAQ describes what an initiative is and why; it does not contain the flow's
   step-by-step mechanics, so silently generating a full use case from it and moving on is not
   a shortcut this skill authorizes. This applies to every downstream skill, not just
   use-case-uml: check each one's own SKILL.md for what it actually permits skipping versus
   what it only permits skipping the *re-derivation* of. Don't assume "don't re-ask what's
   already given" means "don't confirm anything."
4. **Use Case Test Cases** and **Use Case Requirements** for each use case (lettered to
   match, `04a-`/`05a-`, `04b-`/`05b-`, ...).
5. **Architect Review**: both personas, each its own file (`06a-`, `06b-`), plus the opt-in
   debate (`06c-architect-debate.md`), grounded in a short simulated product-manager intake.
6. **Actually run every skill's own self-check before presenting its output** — don't skip
   clean-style, don't skip use-case-uml's actor-consistency check, don't skip
   use-case-requirements' granularity check. If a self-check catches a real bug in the
   skill itself (not just this run's content), fix the skill and record the finding; don't
   just patch this run's output and move on.
7. **Save every stage's real prompts and self-answers to `dialogue.md`** as you go, as actual
   `**Claude:**` / `**User (simulated):**` turns, not third-person narration about what
   happened. Not reconstructed afterward from memory; the point of `dialogue.md` is to show
   what was actually asked and answered, and playback on the examples page only renders real
   turns and section dividers, so prose that never took the form of a turn won't show up
   there at all. Any stage with nothing to confirm (test-cases' mechanical extraction,
   architect-review working from whatever artifacts exist) legitimately has no turns of its
   own; that's fine and should render as a quick pass-through, not padded with fake dialogue.
8. **Write a `README.md`** in the run's folder: what this run stressed, what passed, what
   you found and fixed, what's still open.
9. **If a finding points to a real skill fix** (not just this run's content), add it to the
   top-level `TODO.md`, cross-referenced back to this run.

## Folder and file conventions

Follow `../README.md` (this directory's own README) exactly: `output/YYYY-MM-DD-<slug>/`,
lettered files when there's more than one use case or persona, `dialogue.md` plus numbered
artifacts, a `README.md` with findings.

## After the run exists

If this run is meant for the GitHub Pages gallery, add one entry to the `EXAMPLES` array in
`../../../examples.html`'s script (slug, name, blurb, `hasDialogue`, and a short `artifacts`
list of the run's most worth-reading files). No other page changes needed; the picker and
playback both read from that array.
