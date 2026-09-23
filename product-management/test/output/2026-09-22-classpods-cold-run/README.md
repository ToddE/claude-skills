# ClassPods (cold run)

**Idea generated for this test run, not supplied by whoever kicked it off.** ClassPods is
a small-group classwork tool for K-12 teachers: it builds balanced groups from
participation history, rotates roles automatically, and gives a teacher a live view of
which groups need a check-in, without recording audio or video of students. Chosen for the
education domain specifically because it surfaces FERPA and state student-data-privacy
concerns, a compliance flavor none of the three prior runs (a meta announcement, a city
program, a for-profit home-service SaaS) tested.

## What this run was supposed to stress

This is the **cold run** flagged as a known gap in `../README.md` and
`../GENERATE-EXAMPLE.md`. Unlike the three prior runs, the operator did not invoke each
skill in the pipeline directly. Only `working-backwards-prfaq` was called, through the
`Skill` tool, by name, the way a real first-time user encountering this repo would. Every
step after that was meant to happen only if the currently running skill offered it
unprompted, per its own `SKILL.md`, and if an offered skill wasn't actually available in
the session, the test was to check whether the fallback language (name this repo, point to
installing it) actually fired.

## What actually happened: a naming collision, before any handoff question was reachable

The session this run was executed in does not have this repo's `product-management`
plugin installed at all. It does have `clean-style` from this repo, but none of
`working-backwards-prfaq`, `use-case-discovery`, `use-case-uml`, `use-case-test-cases`,
`use-case-requirements`, or `architect-review`. Separately, the session has an unrelated
skill that happens to share the exact name `working-backwards-prfaq`. **Correction after
follow-up investigation**: this was initially reported as an Anthropic-provided skill from
an `anthropic-skills` plugin; checking `~/.claude/skills/synced/.../manifest.json` directly
shows it's tagged `"source": "custom"` (a personal custom skill synced to that account, date
-stamped the same day as this repo's `init commit`), not `"source": "anthropic"` like the
genuine first-party skills in the same sync bucket (`docx`, `pdf`, `pptx`, `xlsx`). It's an
unrelated custom skill, not an Anthropic-published one. The naming-collision finding itself
still stands; only the attribution of the colliding skill was wrong.

Calling `Skill(skill: "working-backwards-prfaq")` silently ran that unrelated skill
instead of this repo's. There was no error and no signal in the tool output that a
different implementation had answered. Confirmed by direct text comparison against
`../../skills/working-backwards-prfaq/SKILL.md` (see `dialogue.md` for the specific line
diffs). Calling the fully-qualified `product-management:working-backwards-prfaq`
correctly returned `Unknown skill`, an honest and unambiguous error, but nothing about the
bare-name path suggests trying the qualified form, and a real first-time user has no reason
to suspect the wrong skill answered.

**This is a more serious finding than anything this run set out to test.** It means the
handoff-and-fallback behavior documented in every `SKILL.md` in this pipeline is
untestable, and unusable, in any session where a same-named skill from another source is
present, because the wrong one runs and the real one never gets a turn. No amount of
correct handoff logic inside this repo's `working-backwards-prfaq` matters if a
naming collision routes the user's request elsewhere before that logic ever executes.

## Did the skill that actually ran offer a handoff? (expected: no, and it didn't)

The skill that ran (`anthropic-skills:working-backwards-prfaq`) has no instruction
anywhere in its text to check for or offer `use-case-discovery`, and no instruction to
check for or defer to `clean-style` even though `clean-style` genuinely is installed in
this session. It never mentioned either. Asked a natural, unprompted follow-up ("what's
next, once this is in good shape?"), it suggested generic downstream product work
(user stories, MVP scoping) without naming any specific skill or this repo. That is
consistent with its own instructions, which contain no such handoff. It is not a bug in
that skill; it simply isn't the skill this repo ships, and it was never supposed to be
answering.

## Discrepancies against each `SKILL.md`'s own stated behavior

- **`working-backwards-prfaq`** (this repo's version, `product-management/skills/working-backwards-prfaq/SKILL.md`):
  its Step 3 instruction ("check whether `use-case-discovery` is in your current list of
  skills... offer it directly if so, otherwise name this repo and the install path") and
  its clean-style deferral instruction were **never exercised**, because this repo's
  skill never ran. This is not a discrepancy in the skill's own logic, since the logic was
  never reached, but it is a discrepancy in outcome: a user following this repo's
  documented usage (call the skill by its documented name) does not get this repo's
  documented behavior.
- **`use-case-discovery`, `use-case-uml`, `use-case-test-cases`, `use-case-requirements`,
  `architect-review`**: untested in this run for the same root-cause reason. None of them
  were reachable, because the chain never got past step one with this repo's actual code
  running.
- **The unavailable-skill fallback** (documented in `../README.md`: "does Claude say so
  and point to this repo... rather than silently dropping the offer or assuming the skill
  is there") was tested in spirit, just one level higher than intended: instead of an
  *offered* skill silently failing to be flagged as unavailable, the *initially requested*
  skill silently resolved to an unavailable one's namesake. The one clean signal that did
  work correctly was the fully-qualified name's `Unknown skill` error, which is accurate
  and not misleading, it's just not something a user is prompted to try.

## What passed

- The PR/FAQ itself (`01-prfaq.md`), once generated by the substitute skill, is usable,
  specific content: a real problem statement, a real (if simplified, no audio/video)
  mechanism, measurable success metrics, and an honest Internal FAQ risk section including
  the FERPA/state-law compliance angle this domain was chosen to exercise.
- The `Unknown skill` error for the fully-qualified name was clean and non-hallucinated,
  it did not invent a skill or pretend to run one that isn't installed.

## What's still open

- Whether this repo's actual `working-backwards-prfaq` Step 3 handoff and clean-style
  deferral work as written is still **untested**. A follow-up run needs to happen in a
  session where this repo's `product-management` plugin is actually installed and no
  other plugin defines a same-named skill, or with the plugin's skills invoked by
  fully-qualified name throughout, to get past step one.
- Whether `use-case-discovery` correctly offers `use-case-uml`, and whether `use-case-uml`
  correctly offers `use-case-test-cases`/`use-case-requirements`, and whether either of
  those correctly offers `architect-review`, all remain untested by this run.
- The naming-collision problem itself is a finding about the `Skill` tool's name
  resolution and this repo's choice of skill names, not about any one `SKILL.md`'s
  content. Worth flagging in the top-level `TODO.md` (not edited by this run, per this
  run's instructions) so whoever integrates findings across parallel runs can decide
  whether to rename this repo's skills to reduce collision risk, or document that users
  should always invoke them by fully-qualified plugin name.
