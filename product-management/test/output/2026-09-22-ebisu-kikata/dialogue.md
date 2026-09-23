# Dialogue: Ebisu Kaiten-Zushi / Kaiten IQ

Idea generated for this test run, reusing the `use-case-uml` format reference's own worked
example ("Chef Input (Commissioning)") as its source material, per the task's instruction.
Chosen to stress a physical-retail/food-service RFID domain and to reuse existing worked
content honestly rather than re-deriving it, neither of which the five prior runs (a
non-commercial meta announcement, a city-department program, a for-profit home-service
SaaS, an education-sector cold run, and a capital-intensive chip-manufacturing run) tested.

## Before intake: the same namespace collision, confirmed again, tried for real

Before running `working-backwards-prfaq`'s intake, this run called the real `Skill` tool:
`Skill(skill: "working-backwards-prfaq")`. It launched successfully but loaded an unrelated
skill from a different plugin (`anthropic-skills`), not this repo's own
`product-management/skills/working-backwards-prfaq`. Confirmed by diffing the loaded
instructions against `../../skills/working-backwards-prfaq/SKILL.md` directly: the loaded
version has no audience-generalization language (it's commercial-product-only, "the
customer" hard-coded rather than "whoever is served"), no clean-style deferral section, and
no use-case-discovery handoff offer, all of which this repo's actual file has.

This is not a new finding. It's the exact collision `2026-09-22-classpods-cold-run/README.md`
documented first and `2026-09-22-continental-circuits/dialogue.md` confirmed again: the
`product-management` plugin isn't installed in this session, and a same-named skill from
another plugin silently answers instead of erroring. This run does not re-report it as new.
Per the same workaround every non-cold prior run used, this run read
`product-management/skills/working-backwards-prfaq/SKILL.md` and
`references/methodology.md` directly from this repo and executed that documented procedure
by hand, stage by stage, self-answering as Ebisu Kaiten-Zushi's founder. `clean-style` and
`use-case-discovery`'s underlying instructions are genuinely present as project-scoped
skills in this session (confirmed by `Skill(skill: "clean-style")` loading from
`/home/emerson/Workspace/claude-skills/.claude/skills/clean-style`, this repo's own copy,
not a colliding one), so those two were invoked for real through the `Skill` tool.

## working-backwards-prfaq intake

Conducted by following `product-management/skills/working-backwards-prfaq/SKILL.md`'s Step 1
five-stage interview directly, one question at a time.

**Claude (Stage 1):** What are you announcing?

**User (simulated, as founder Aiko Tanaka):** Ebisu Kaiten-Zushi, an 18-location kaiten-zushi
(conveyor-belt sushi) chain based in Torrance, California, is licensing Kaiten IQ, an RFID
plate-tracking platform we built for our own restaurants, to other conveyor-belt sushi
operators. Every plate gets an RFID chip. When a chef commissions a menu item onto plates,
Kaiten IQ records the item and a "born on" timestamp in Live Inventory instead of a
handwritten note. Belt antennas track every plate in real time and flag one automatically
once it reaches its freshness window, and checkout tallies a guest's plates by color in
seconds instead of a hand count.

**Claude (Stage 2):** Who is this for, specifically? What problem does it solve for them, and
how are they dealing with it today?

**User (simulated):** Kaiten-zushi and conveyor-belt restaurant operators running 5 to 50
locations, still using a colored-plate-and-paper-timer system: a server notes what time a
plate went on the belt and pulls it after a set window, by memory or a sticky note. When
staff turn over mid-shift or get pulled onto something else, a plate sits past its window
and a health inspector documents it. At checkout, a server counts plate colors by hand or
scans barcode stickers one at a time, which slows table turns and produces disputes when a
plate gets miscounted.

**Claude (Stage 3):** What makes it meaningfully different, and how will you know it worked?

**User (simulated):** No competitor targets kaiten-zushi specifically with chip-level plate
tracking; general RFID inventory vendors track back-of-house stock, not plates circulating
in front of guests. Success: within 18 months of general licensing availability, 40 licensed
locations beyond our own 18, a measurable drop in average checkout time per table, and no
licensee reporting a health-code freshness citation tied to a plate Kaiten IQ was actively
monitoring.

**Claude (Stage 4):** How many stakeholders should be quoted, and who?

**User (simulated):** Two. Me, Aiko Tanaka, founder and CEO, on why chip-level tracking
matters for food safety and guest trust. And Marcus Webb, VP of Restaurant Operations, on
what actually changes for kitchen and floor staff going from paper timers to Kaiten IQ.

**Claude (Stage 5):** Timeline, and anything else I should know?

**User (simulated):** Pilot licensing with three operator locations starts now; general
licensing availability is dated March 2, 2027. One more thing: RFID tag durability under
commercial dishwasher cycles and constant belt friction is our biggest open technical risk.
A tag that fails early makes a plate with no timestamp indistinguishable from one that was
never at risk, which undermines the whole freshness-enforcement pitch. The pilot has to
prove tag survival at real volume, not just in a lab.

**Claude:** Recap confirmed before generating (see `01-prfaq.md`). This is a
physical-retail/food-service initiative with a real-time IoT flavor, so the Internal FAQ
leans on tag durability, RFID hardware unit economics, and staff-adoption risk instead of
the compliance or supply-chain risk language the prior manufacturing and healthcare-adjacent
runs used.

### Self-check: clean-style (real skill, genuinely installed in this project)

`clean-style` loaded from this repo's own `.claude/skills/clean-style` directly (confirmed
by the base directory printed in the launch), so this is a real invocation, not a manual
simulation. Findings from applying `references/rules.md` to the drafted `01-prfaq.md`:

- **Undefined jargon on first use**: "kaiten-zushi" appeared in the press release's dateline
  paragraph before any reader unfamiliar with the term would know what it means, even
  though the headline glosses it as "conveyor-belt sushi." Fixed by adding an inline
  parenthetical gloss on the term's first full-sentence use: "an 18-location kaiten-zushi
  (conveyor-belt sushi) chain."
- Checked and passed: no em-dashes, no sentences opening with a broad quantifier
  ("Every"/"All"/"Each"; this was a known pattern flagged and fixed in the
  `continental-circuits` run, and this draft was written to avoid it from the start rather
  than fixed after the fact), no passive-voice placeholder pattern like
  `dispatchiq`'s/`continental-circuits`'s "[X] to be finalized before general availability"
  (this draft used "Ebisu Kaiten-Zushi finalizes pricing tiers" instead, active voice, on
  the first pass), no contrastive antithesis, no "real" used as a throwaway intensifier.

No other violations found.

## use-case-discovery

Followed `use-case-discovery/SKILL.md` Steps 1-3 directly (manual, since the plugin
collision prevents the real `Skill` tool from reaching this repo's copy). Derived goals and
three candidate use cases from the confirmed PR/FAQ brief (see `02-use-case-candidates.md`).

**Self-check applied (Step 3, actor-name consistency and candidate-shape review):**
- Confirmed "Kaiten IQ" is used as the single, consistent name for the platform across all
  three candidates, never "the system" or "the platform" inconsistently, the same discipline
  `continental-circuits` applied to "Continental ERP."
- Considered whether "Chef Input (Commissioning)" and "Automatic Freshness Pull" are secretly
  one use case with an Alternate Path, the same question the format reference's own worked
  example raises for "Subscriber Session." Decided against merging: each has its own
  distinct trigger (a chef's manual action vs. Kaiten IQ's own continuous, unattended
  monitoring) and its own actor sequence, meeting the granularity bar the skill sets, unlike
  the format reference's "Subscriber Session" example, which genuinely had no trigger of its
  own.
- Confirmed with the (simulated) founder that all three candidates should be drafted in full,
  in plate-lifecycle order: commissioned, then monitored for freshness, then billed.

## use-case-uml

**Claude:** For "Chef Input (Commissioning)," reusing `use-case-uml/references/format.md`'s own worked example almost verbatim per this task's instruction, renaming its generic "System" actor to "Kaiten IQ" for consistency with the other two use cases. Before treating that as final: does a real commissioning flow at an Ebisu location actually work this way, chef places tagged plates in a workspace, touches the menu item on a touch screen, confirms the scan, or does the worked example's flow not quite match how your chefs would do it?

**User (simulated, as founder Aiko Tanaka):** That's genuinely how it works, plate-then-touch-then-confirm is close to what we prototyped. Keep it as-is.

**Claude:** Kept it as reused, with only the actor rename and the Post-Condition's "born on" timestamp language tied forward to what 03b and 03c both depend on. See `03a-chef-input-commissioning.md`.

**Claude:** "Automatic Freshness Pull" and "Checkout Plate Tally" have no worked example to reuse, so these are drafted directly from the confirmed PR/FAQ and candidates rather than an open interview, per `use-case-uml/SKILL.md` Step 1. Drafted "Automatic Freshness Pull": belt antennas continuously read plate tags, Kaiten IQ calculates elapsed time since each plate's "born on" timestamp, flags one that's crossed its menu-item category's freshness threshold, and Floor Staff retrieves and confirms removal. Branches for a proactive quality-defect removal, a flagged plate a guest takes before Floor Staff arrives, and a damaged/undetected tag. Does per-menu-item-category freshness thresholds (nigiri vs. a mayonnaise-based roll) match how spoilage risk actually varies on your belt?

**User (simulated, as founder Aiko Tanaka):** Yes, category-level thresholds are right, individual-plate thresholds would be overkill. One real question this raises: can a licensee location set tighter thresholds than ours for the same category, say for a hotter kitchen?

**Claude:** That's not resolved by anything in the PR/FAQ, flagging it as an Open Issue rather than deciding it here. See `03b-automatic-freshness-pull.md`.

**Claude:** Drafted "Checkout Plate Tally," building on 03a and 03b: guest signals readiness to pay, Cashier has them stack plates on a checkout RFID reader, Kaiten IQ reads every tag, tallies by price tier, and closes each plate's record as sold once payment's confirmed. Branches for a guest disputing the tally, an unreadable plate in the stack, and a guest presenting a plate 03b already flagged for removal. For that last one, I drafted the Cashier as deciding sell-at-full-price, discount, or decline, house policy isn't specified in the PR/FAQ. Does that three-way choice match reality, or is there always a single house rule?

**User (simulated, as founder Aiko Tanaka):** There's no single rule yet, it really does depend on the manager on duty and how obviously off the plate looks. Leave it as a Cashier judgment call with the three options.

**Claude:** Left `[DISCOUNT_POLICY]` as an Open Issue rather than picking one of the three as a default. See `03c-checkout-plate-tally.md`.

**Claude:** Step 3 self-check, run for real against all three use cases:
- Actors and Basic Path stay in sync in all three: every listed Actor (Chef, Kaiten IQ, Floor Staff, Guest, Cashier) appears at least once in its use case's Basic Path, not only in an Alternate/Exception Path. No repeat of the `continental-circuits` run's "Sourcing Manager only in Exception Paths" bug turned up here.
- All three Basic Paths end with the literal `| | | END OF USE CASE |` row, and every Alternate/Exception Path references a real step number and ends with either a rejoin or "End of use case."
- No two consecutive Basic Path rows are the same actor performing the same, non-branchable action; `03b`'s and `03c`'s runs of 3-4 consecutive same-actor rows were checked against this specifically, and each action is distinct and independently branchable.
- Actor names (Chef, Kaiten IQ, Floor Staff, Guest, Cashier) are identical across all three documents. "Floor Staff" and "Cashier" were deliberately kept separate even though one person fills both roles at a small licensee location, naming distinct responsibilities, not job titles.
- No genuine bug found in this run's drafting itself, unlike `continental-circuits`. Worth stating plainly rather than manufacturing a finding: this self-check worked exactly as `use-case-uml/SKILL.md` describes it, and this run's content passed it on the first pass.

## use-case-test-cases / use-case-requirements

Ran Mode A against all three use cases. Test cases (`04a`, `04b`, `04c`) generated one per
Basic, Alternate, and Exception Path, with Expected Results copied from each use case's
Post-Condition(s) at the matching exit point, never paraphrased; where a path rejoins the
Basic Path rather than terminating (e.g. `04a`'s two Exception-Path test cases), the
Expected Result states the state left behind at the rejoin point instead of the eventual
Basic Path outcome, per the test-case format's own convention for that case.

Requirements (`05a`, `05b`, `05c`) applied the granularity self-check deliberately, having
read `continental-circuits`' and `dispatchiq`'s documented under-decomposition findings
first:
- `05a` (Chef Input) split Basic Path steps 5 and 6 (detecting which tags are in the
  workspace vs. associating them with the menu item) into two requirements rather than one,
  since each has an independently nameable failure mode ("saw the wrong tags" vs.
  "associated the right tags with the wrong item").
- `05b` (Automatic Freshness Pull) split Exception Path A's removal-marking step from its
  discrepancy-logging step into two requirements (`REQ-FreshnessPull-08` and `-09`), the
  exact "and"-joined-effects pattern the granularity rule calls out by name and the same
  pattern `continental-circuits` found in its own Exception Path A.
- `05c` (Checkout Plate Tally) split Basic Path step 3 (reading tags vs. retrieving each
  plate's price tier from Live Inventory) into two requirements for the same reason as
  `05a`'s split, and explicitly declined to write a requirement for Basic Path step 8
  (Cashier processes payment), since payment processing itself is out of scope per
  `02-use-case-candidates.md`'s own scope note; inventing a Kaiten IQ payment requirement
  there would have violated the skill's "don't invent a requirement not stated in the use
  case" rule in the other direction, by tracking something explicitly out of scope.
- Also merged, deliberately, where merging was the right call: `05c`'s Alternate Path A
  override recalculation and audit-log write combine into one requirement
  (`REQ-CheckoutTally-07`), since a single override action always produces both effects
  together as one atomic, single-observable-outcome handoff, the same merge criterion the
  format spec itself uses for `ClientUpdate`'s steps 6-10.

Final requirement counts: 7 for `05a`, 12 for `05b`, 13 for `05c`, reflecting genuinely more
distinct effects across use cases with more Alternate/Exception Paths, not padding.

## architect-review

Followed `architect-review/SKILL.md` Steps 1-6 for both personas separately (`06a`, `06b`),
grounded in the PR/FAQ, all three use cases, and all three requirements sets. Both personas'
recommendations trace to specific requirement IDs (`REQ-FreshnessPull-01` through `-04`'s
continuous-read requirement, `05c`'s tenant-isolation-relevant requirements) or specific
PR/FAQ language (the tag-durability risk, the licensee-operator audience with "no IT staff
of their own" implied by the External FAQ's single-visit installation claim).

### Debate opt-in: product-manager intake

**Claude:** Want me to run a debate between the two architects on this one?

**User (simulated):** Yes.

**Claude:** Budget sensitivity: how tight is it, and is that permanent or temporary?

**User (simulated):** Tight, and structural, not a phase we grow out of. We're a restaurant
company funding this software spinout out of our own operating margin, not a funded startup
with a runway clock. There's no future funding round that loosens this.

**Claude:** Operational appetite: does the team want to run infrastructure themselves, or
minimize that?

**User (simulated):** Minimize it. We hired two engineers away from a restaurant-tech vendor
to build this; nobody else is free to run infrastructure on top of their actual work.

**Claude:** Failure visibility: if something breaks at 2am, who finds out today, and how
fast?

**User (simulated):** Nobody, today. If freshness detection silently stops working at a
licensee location, we find out when a manager notices a stale plate on the belt, or when a
health inspector does. There's no monitoring at all right now, just a support phone line
licensees can call.

**Claude:** Risk tolerance: which hurts more, being locked into a vendor, or your own system
breaking in a way only your team can fix?

**User (simulated):** Neither framing is quite it. What actually worries us is a silent
failure at a restaurant we don't staff and can't just walk into on a bad night. Vendor
lock-in on a small piece of infrastructure doesn't scare us the way that does.

**Claude:** Timeline pressure: how urgent is going live, and what's riding on it?

**User (simulated):** The pilot with three licensee locations needs to be reliable before we
open general licensing. Our own PR/FAQ's success metrics (checkout time reduction, no
freshness-related health-code citations) depend on those three locations proving out.

**Claude:** Recap confirmed, debate drafted. See `06c-architect-debate.md`.
