# Standalone Mode Verification — 2026-09-23

Every existing example run under `product-management/test/output/` chains
`working-backwards-prfaq` into all five downstream skills, so each downstream skill's
documented "don't re-ask if already given" rule fires and its own intake never actually
runs — every prior run just says something like "derived directly from the confirmed
PR/FAQ brief" and moves on. Every one of those five skills' `SKILL.md` files also documents
that it works standalone, cold, with its own real interview or gathering logic, but that
claim had never once been exercised anywhere in this repo. This run exists to close that
gap: five separate, unrelated cold invocations, one per downstream skill, with no PR/FAQ, no
prior use case, and no shared context between any of the five.

**Tooling note:** the real `Skill` tool was tried first (`Skill(skill: "use-case-discovery")`)
and returned `Unknown skill`, meaning none of these five skills are registered as callable in
this session — not even under a colliding name from another plugin, which is a different and
more complete failure than the previously documented `working-backwards-prfaq` collision.
Per this task's own instructions for that class of problem, each skill's current `SKILL.md`
and `references/format.md` (plus, for architect-review, both persona files) were read in
full, and its documented workflow was then executed by hand, self-answering as a plausible
user. See `dialogue.md` for the full transcripts and this exact explanation in place.

## use-case-discovery

**Worked as documented: yes.** Given only the one-line premise ("volunteer shift-scheduling
tool for a food pantry, what use cases do I need"), it did not skip to a candidate list. It
ran the real Step 1 interview (what it is, who/what's involved, goals, out of scope) as four
separate questions, then produced a six-row candidate table matching `references/format.md`
exactly, then ran the Step 3 review pass by explicitly asking the user to confirm actor-name
consistency and flagging one genuine judgment call before presenting: the
"Automatic Under-Staffed Shift Escalation" candidate has a time-triggered, not user-triggered,
Rough Trigger, so it was filled in explicitly rather than left blank, since a blank trigger
is documented as a signal a candidate might really be a continuation of another one, and this
one isn't. Step 4's handoff offer correctly checked whether use-case-uml was available before
offering it, and correctly disclosed that it wasn't in this session rather than assuming it
was. No mismatch found between documented and actual standalone behavior.

## use-case-uml

**Worked as documented: yes.** Given only a one-line flow description ("write a use case for
how a returned online order gets restocked at a warehouse") with no use-case-discovery
candidate behind it, it ran the real Step 1 interview (assumptions, actors, trigger, happy
path, known variations) instead of generating from the one-liner, and specifically dug into
whether the "wrong item in box" variation was a dead end or a rejoin, since that distinction
determines whether it's written as an Alternate Path with a rejoin or an Exception Path with
a terminal exit. The resulting use case passed its own Step 3 self-check (actor/Basic Path
sync, literal `END OF USE CASE` row, valid path references, no consecutive same-actor
non-branchable rows, per-exit-point Post-Condition(s), correct section order). One genuine,
if minor, documentation inconsistency was found and fixed while doing this: `SKILL.md`'s
Step 3 self-check bullet allowed `TBD` as a valid Alternate Path ending, but
`references/format.md` only documents `TBD` for Exception Paths (Alternate Paths are known
valid variations, so an unresolved `TBD` shouldn't apply to them). Fixed directly in
`product-management/skills/use-case-uml/SKILL.md`.

## use-case-test-cases

**Worked as documented: yes.** This skill's own standalone entry point isn't "zero input" —
its `SKILL.md` requires a full completed use case, pasted or pointed to. A freshly-written
use case ("Library Book Hold Pickup," not reused from anywhere else in this repo) with a
Basic Path, one Alternate Path, one Exception Path, and per-exit Post-Condition(s) was pasted
directly into the conversation. It correctly recognized the use case was complete enough to
proceed without stopping to ask for a missing or narrative Post-Condition(s) section (the
stop condition `SKILL.md` documents for an incomplete input), enumerated the three paths in
the documented order (Basic, then Alternate, then Exception), and produced three test cases
with Expected Results copied verbatim from the matching Post-Condition(s) bullets, not
paraphrased or invented. No mismatch found between documented and actual standalone
behavior.

## use-case-requirements

**Worked as documented: yes, Mode B.** Given a feature idea with explicitly no use case
("no use case yet: a two-factor-authentication reminder banner..."), it correctly selected
Mode B rather than asking the user to go produce a use case first, and ran the real
three-stage interview (what it is; who/what problem, pushed past "users" for a specific
segment and a specific traced problem; concrete Stage 3 behaviors, explicitly probing show
condition, dismiss/resume timing, escalation, and an excluded user segment). It recapped and
confirmed before generating, asked directly for a priority scale rather than guessing one
(the user supplied High/Medium/Low), and every requirement's Source cited a specific
interview stage/topic rather than a fabricated use case reference. Both the CSV and GitHub
Issues exports were generated per the documented column/block spec. No mismatch found
between documented and actual standalone behavior.

## architect-review

**Worked as documented: yes.** Given only a one-line idea with nothing else ("a personal
budgeting app that syncs balances across two people's phones"), it did exactly what its own
Step 1 says to do for that case: it asked the user to describe the idea further rather than
requiring a PR/FAQ or use case first, and it said plainly, in the Inputs Considered header of
both persona outputs, that the recommendation is less grounded as a result. It listed both
available personas, ran both (rather than defaulting to one) since the user asked to compare,
and produced two fully separate, persona-distinct recommendations, each tracing its major
calls either to something the user said in the clarifying exchange or to that persona's own
stated philosophy (buy-over-build for The Assembler; modulith-first, named-risk-driven
tradeoffs for The Pragmatic Modulith Architect) rather than swapping a preferred stack onto
generic advice. It correctly offered the opt-in Step 7 debate only after presenting both
standalone recommendations, and did not run it automatically when the user declined. No
mismatch found between documented and actual standalone behavior.

## Bug fixed during this run

`product-management/skills/use-case-uml/SKILL.md`, Step 3 self-check: allowed `TBD` as a
valid Alternate Path ending, which its own `references/format.md` doesn't sanction (`TBD` is
documented there only for Exception Paths). Corrected in place; see the file's current Step 3
section.
