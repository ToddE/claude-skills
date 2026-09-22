# Pipeline test runs

End-to-end runs of the skill pipeline, kept in the repo so results are reviewable instead
of thrown away after a session. Not published documentation; treat this as QA evidence.

## Folder convention

One folder per run, under `output/`, named `YYYY-MM-DD-<slug>` where `<slug>` is a short
name for the product idea that run used (dated so multiple runs on the same idea don't
collide, sluggable so the idea is visible in the folder name without opening anything).

Each run folder contains:

- **`dialogue.md`**: the actual prompts and responses for each intake stage across every
  skill in the run, not just the final documents. This is what makes a run reviewable:
  seeing what was asked and answered, not only what came out the other end.
- **Numbered artifact files**: one per skill, in pipeline order (e.g. `01-prfaq.md`,
  `02-use-case-candidates.md`, ...), the output each skill produced. Most initiatives have
  more than one use case; when they do, each one gets its own lettered file at that step
  (`03a-<slug>.md`, `03b-<slug>.md`, ...) instead of one combined file. Separate files are
  what exercises use-case-uml's actor-consistency rule across a set of use cases, and each
  one stays independently reviewable and diffable. The architect-review step follows the
  same pattern: one lettered file per persona (`06a-<persona-slug>.md`,
  `06b-<persona-slug>.md`, ...), and if a debate between personas is run, its own file named
  `<fileid>-architect-debate.md` (e.g. `06c-architect-debate.md`), never merged into a
  persona's own file.
- **`README.md`**: a short summary of the run: what was tested, what passed, what didn't,
  any gaps found in the skills themselves. Findings that point to a skill fix belong in the
  top-level `TODO.md`, not buried in a run folder.

## What every run should verify

Beyond producing correct artifacts, `dialogue.md` should show whether:
- Each skill works standalone, not just as a link in the chain. A skill should never
  require a downstream or upstream skill to function; it can only offer to hand off to
  one.
- "Offer the next step" happens: does the skill surface the handoff unprompted, the way
  its own `SKILL.md` says to, or does it only happen because the test operator already
  knew to ask for it?
- The unavailable-skill fallback works: when an offered next skill isn't in the current
  session's available skills, does Claude say so and point to this repo for installing it,
  rather than silently dropping the offer or assuming the skill is there?

## Generating the product idea

Runs don't have to use a fixed, pre-supplied idea. A run can start from a product idea
generated for that run alone, so the pipeline gets exercised on something it wasn't
designed around. When that's the case, say so in the run's `README.md` and in `dialogue.md`
so it's clear the idea wasn't seeded by whoever kicked off the test.

## Known gap

`2026-09-22-claude-skills-meta`, the first run, predates this convention and has no
`dialogue.md`; it went straight to a compact summary of each intake instead of a full
transcript. Later runs should include the dialogue.
