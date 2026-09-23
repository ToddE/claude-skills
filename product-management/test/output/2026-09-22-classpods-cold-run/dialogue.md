# Dialogue: ClassPods (cold run)

Idea generated for this test run, not supplied by whoever kicked it off. This run is the
**cold run** flagged as a gap in `../../README.md` and `../GENERATE-EXAMPLE.md`: unlike the
three prior runs, the operator here did not invoke each skill directly in sequence. Only
`working-backwards-prfaq` was invoked, by name, through the `Skill` tool, the way a real
first-time user would. Every step after that was supposed to happen only if the running
skill offered it unprompted, per its own `SKILL.md`.

That is not how this run went, starting at step one. The collision below is the headline
finding of this run, ahead of anything about downstream handoffs.

## Before the interview: a naming collision, not a handoff failure

The operator's Claude Code session for this run does **not** have this repo's
`product-management` plugin installed. Its available-skills list contains a
`clean-style` skill from this repo, but not `working-backwards-prfaq`,
`use-case-discovery`, `use-case-uml`, `use-case-test-cases`, `use-case-requirements`, or
`architect-review`. It does have an unrelated, differently-authored skill that happens to
share the exact same name, `working-backwards-prfaq`, installed from a different plugin
(`anthropic-skills`, synced from `/home/emerson/.claude/skills/synced/...`).

Calling `Skill(skill: "working-backwards-prfaq")`, exactly what a user reading this
repo's own instructions would type, silently launched the **wrong skill**. There was no
error, no disambiguation prompt, and no indication anywhere in the tool output that a
different, unaffiliated implementation had run instead of this repo's. The only way to
tell was to read the injected skill instructions carefully and compare them line-by-line
against `product-management/skills/working-backwards-prfaq/SKILL.md`.

For confirmation, a second call was made with the fully-qualified name:

> `Skill(skill: "product-management:working-backwards-prfaq")`
> → `Unknown skill: product-management:working-backwards-prfaq`

That error is correct and unambiguous, it says plainly that the repo's plugin isn't
installed under that name. But nothing prompts a user to try the qualified form; a user
typing the bare, documented skill name gets a confident, fully-formed guided interview
from a skill that isn't this one, with no signal that anything is wrong. See `README.md`
for why this matters more than the handoff questions this run set out to test.

Differences between what actually ran (`anthropic-skills:working-backwards-prfaq`,
paraphrased from its injected instructions) and this repo's real
`product-management/skills/working-backwards-prfaq/SKILL.md`, confirmed by direct
comparison:

- The repo's version generalizes to any announcement (nonprofit, campaign, internal
  program) and explicitly asks how success is measured for *this* initiative rather than
  assuming revenue. The version that ran is commercial-product-only ("elite Product
  Manager", "the customer", TAM/unit-economics framing throughout).
- The repo's version has an explicit Stage 3 prompt for a measurable success definition
  ("How will you know this worked?"). The version that ran does not ask this as its own
  question; it only asks what makes the offering different.
- The repo's version has an explicit instruction at the end of Step 3: check whether
  `use-case-discovery` is in the available-skills list, offer it directly if so, or name
  this repo and the install path if not. **The version that ran has no such instruction
  anywhere.** It does not mention `use-case-discovery`, this repo, or any downstream skill
  at all.
- The repo's version has an explicit instruction to check for `clean-style` before
  drafting and self-check against it, with a fallback message if `clean-style` isn't
  available. The version that ran has its own inline writing-rules checklist and never
  checks for or mentions `clean-style`, even though `clean-style` genuinely is installed
  in this session.

Because the wrong skill ran, none of the intended handoff behavior for
`working-backwards-prfaq` could be tested at all in this run. What follows is the actual
interview as conducted by the skill that did run, self-answered as the founder, since
that is what a real cold user would have experienced.

## working-backwards-prfaq intake (as run by `anthropic-skills:working-backwards-prfaq`)

**Claude (Stage 1):** What are you announcing?

**User (simulated, founder):** ClassPods. It helps K-12 teachers run small-group
classwork, forming balanced groups instead of hand-picked ones, rotating roles like
facilitator, recorder, timekeeper, and presenter automatically, and letting the teacher
log who's contributing with a one-tap gesture while circulating the room, so the same two
kids don't run every group project for the whole year.

**Claude (Stage 2):** Who is the customer, specifically, and what problem does this solve
for them today?

**User (simulated):** General-education teachers in grades 3 through 8, in schools with a
1:1 iPad program, who assign small-group classwork or projects at least twice a week.
Today they build groups from memory or a spreadsheet, usually by friendship or convenience
rather than by skill balance, and once the groups start working there's no way to see who's
actually contributing until the teacher physically walks over to a table, which for a
class of 28 kids in six groups means most groups get checked once, maybe twice, in a
40-minute period. Struggling readers and quieter kids end up permanently in the passive
role because nothing ever forces a rotation.

**Claude (Stage 3):** What makes this meaningfully better than what they do today?

**User (simulated):** Two things happen automatically that never happen by hand: groups
get rebalanced based on the participation history the teacher has already logged, so the
same three kids can't coast into the same group together indefinitely, and roles rotate
on their own so a student who was always the recorder last month is the presenter this
month. During the session, the teacher's one-tap log per group builds a live view showing
which groups haven't been checked on, instead of the teacher just guessing based on which
table is loudest.

**Claude:** How will you know it worked?

**User (simulated):** 3,000 active teacher accounts across at least 40 districts within
the first year. At least 70% of teachers who start using it are still running two or more
ClassPods sessions a week by their eighth week, since a one-time trial that gets abandoned
doesn't mean anything. And in an end-of-term survey, at least 60% of teachers report that a
student who normally coasts was visibly more engaged during group work this term than
before.

**Claude (Stage 4):** How many stakeholders should be quoted, and who are they?

**User (simulated):** Two. Mia Alvarez, founder and CEO, a former 5th-grade teacher, whose
angle is watching the same three kids run every group project for years and finally
building the tool she wanted as a teacher. And Dana Whitfield, principal at Overlook
Elementary, one of the pilot schools, whose angle is what changed in her classroom
walkthroughs once teachers started using it.

**Claude (Stage 5):** What's the timeline, and anything else I should know?

**User (simulated):** Pilot with three elementary schools starting spring semester, Q1
2027. General availability for districts in Q3 2027, timed to the start of the next school
year, since that's when districts actually buy. One more thing: this touches student data,
participation counts tied to roster identities, so it's an education record under FERPA,
not just app telemetry. No audio or video is recorded, on purpose, specifically to avoid
opening a consent and biometric-data question the product doesn't need to answer to solve
the actual problem. Pricing is a per-teacher annual seat, with a discounted per-seat rate
at 100+ teachers for a district contract, and a free single-teacher trial tier to drive
bottom-up adoption ahead of the district sales cycle.

**Claude:** Recap confirmed before generating (see `01-prfaq.md`).

## After the PR/FAQ: testing whether a handoff got offered anyway

The document was generated and presented. Per its own Step 3 ("Offer to iterate. [...] The
first version is a starting point, not a finished product"), the skill offered only to
revise the PR/FAQ further, nothing else.

A natural follow-up was asked, the way a real first-time user might, without naming any
other skill:

**User (simulated):** What's next, once this is in good shape?

**Claude (actual response, paraphrased):** Suggested continuing to iterate on the PR/FAQ
itself (tightening the Internal FAQ's risk section, adding a second draft pass), and
separately suggested normal downstream product work in generic terms, breaking this into
a project plan, writing user stories, scoping an MVP, without naming any specific skill,
this repo, or an install path. It did not mention `use-case-discovery`, did not check any
available-skills list, and did not say anything was missing or worth installing.

That is the expected behavior for this skill, since it has no handoff instruction to
follow. It is also exactly the failure mode this cold run exists to catch, just one step
earlier in the chain than expected: not "the real skill forgot to offer its handoff," but
"the real skill never got a chance to, because a same-named skill from an unrelated plugin
answered instead, indistinguishably from the user's side of the conversation."

The run stops here. Per the run's own ground rules, a stalled handoff isn't something to
force forward manually. There is no legitimate way, from this session, to invoke this
repo's real `working-backwards-prfaq`, `use-case-discovery`, `use-case-uml`,
`use-case-test-cases`, `use-case-requirements`, or `architect-review`; none of them are in
the available-skills list, and the one bare name that overlaps resolves to a different
skill entirely. Continuing the pipeline from here (by, say, reading this repo's
`use-case-discovery/SKILL.md` directly and role-playing what it would say) would produce
content, but it would not be evidence of anything this repo's own skills actually do in a
real session, which is the entire point of a cold run.
