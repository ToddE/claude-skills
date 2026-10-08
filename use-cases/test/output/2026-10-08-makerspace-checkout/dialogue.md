# Dialogue: Foundry Makerspace Tool Checkout (use-case-builder, cold)

Cold run of `use-cases/skills/use-case-builder/SKILL.md`: no PR/FAQ, no other skills, one
loose request to start. The skill was followed by hand from its `SKILL.md` and reference
files, with the user's side simulated.

## Phase 1: Discovery

**User (simulated):** Our makerspace wants members to check out tools themselves instead of
signing a paper binder at the front desk. What use cases do we need?

**Claude:** I'll start with a quick picture of the initiative, then propose a list of use
cases for you to review before I write any of them out. Four questions:

1. What is it, in a sentence or two? For example, is this a kiosk in the shop, a phone app,
   or both?
2. Who and what is involved? Rough names are fine: people, devices, and systems.
3. What does it need to accomplish?
4. What's out of scope for now?

**User (simulated):** We're Foundry Makerspace, about 300 members. It's a kiosk by the tool
wall with a badge reader and an RFID scanner; every tool already has an RFID tag. Members
take tools home for a few days. Involved: members, the kiosk, our member database (it has
membership status and which safety classes each person passed), a tool database, shop staff,
and we already use a notification service for email and SMS. Goals: know who has each tool
and when it's due, block tools that need training the member doesn't have, and stop staff
from chasing overdue tools by hand. Out of scope: late fees, reservations, and maintenance.

**Claude:** Thanks. Here's my understanding: a badge-and-scan kiosk that records tool loans,
enforces safety training, and automates overdue reminders, replacing the paper binder.
Here are the candidate use cases:

| Name | Summary | Rough Actors | Rough Trigger |
| --- | --- | --- | --- |
| Member Tool Checkout | A member checks out a tool at the kiosk so the makerspace knows who has it and when it is due back. | Member, Kiosk, Member Database, Tool Database, Notification Service | Member taps their badge at the Kiosk. |
| Tool Return | A member returns a tool at the kiosk so it shows as available again. | Member, Kiosk, Tool Database | Member scans a tool at the return shelf. |
| Overdue Tool Reminder | The tool database reminds a member to return a tool that has passed its due time, and alerts shop staff if it stays overdue. | Tool Database, Notification Service, Member, Shop Staff | A checkout passes its due time with no return recorded. |
| Training Record Update | Shop staff record a member's completed safety training so the kiosk can allow checkout of tools that require it. | Shop Staff, Member Database | Member finishes a safety class. |

Please check three things:
- Actor names: is "Tool Database" what your team calls it? Whatever we pick has to stay the
  same in every use case.
- Should any of these merge or split?
- Anything missing or worth cutting?

I put Notification Service on Member Tool Checkout for a checkout receipt. Tell me if you
don't send receipts.

**User (simulated):** Call it "Inventory," that's what everyone here says. Keep all four. We
don't send receipts today, but leave Notification Service on checkout for now; we might.

**Claude:** Updated: "Tool Database" is now "Inventory" in every row. The confirmed list is in
`01-use-case-candidates.md`.

## Phase 2: Drafting

**Claude:** I'll draft in table order. Do you want them one at a time (better if the flow
details still need discussion) or as a batch?

**User (simulated):** One at a time. Start with checkout, then do the overdue reminder. We'll
do the other two later.

**Claude:** Here's my draft of the checkout flow, before I format it in full. Correct
anything that's wrong:

1. Member taps badge; Kiosk gets the member record from Member Database.
2. Kiosk verifies the membership is active, then prompts for a tool scan.
3. Member scans the tool; Kiosk gets the tool record from Inventory.
4. Kiosk checks the tool is available and that Member has its required training.
5. Kiosk asks Member to confirm the checkout and due time; Member confirms.
6. Inventory records the checkout; Kiosk shows the confirmation.

Variations I'd expect: a tag that won't scan, cancelling, checking out several tools at once,
an inactive membership, Inventory being down, the tool already showing as checked out, and
missing training. A few questions:
- If a member lacks the training, is that a hard stop, or can someone override it?
- If Inventory is down, what should the kiosk tell people?
- No receipt means Notification Service doesn't act in this flow. Should I drop it from this
  use case's Actors?

**User (simulated):** Staff can override missing training if they're on shift: they badge in
at the kiosk and approve it, and we want their ID on the record. If Inventory is down, point
people to the paper log at the front desk. Yes, drop Notification Service from this one. For
the "already checked out" case, I don't know yet; someone probably forgot to return it.

**Claude:** Got it. I'll write the "already checked out" case as an exception path with TBD
and note the decision in Open Issues.

*(Self-check before presenting, per SKILL.md Step 7. The first draft had Basic Path step 9
as "Checks that the tool is available and that Member has its required training." Two
exception paths branched from that one step, labeled E9a and E9b, and the step broke the
"one action per step" writing rule. Split into step 9 (availability) and step 10
(training), so the exception paths became E9 and E10, and later steps were renumbered.
Shop Staff acts only in E10 and stays listed in Actors. Notification Service never acts and
is not listed. All other checks passed.)*

**Claude:** Here's the full use case: see `02a-member-tool-checkout.md`. Notes:
- Shop Staff appears only in Exception Path E10, the override. That's enough to list them as
  an actor.
- Notification Service is off this use case's Actors, per your answer.
- Two alternate paths branch from step 6, so they're labeled A6a (tag won't scan) and A6b
  (cancel).
- Open Issues covers what happens if staff decline or don't respond, how the kiosk alerts
  staff, and the "already checked out" decision.

Does this match how it should work?

**User (simulated):** Yes. Next one.

**Claude:** Draft of the overdue reminder:

1. Inventory detects a checkout past its due time and marks it Overdue.
2. Inventory asks Notification Service to send a reminder; it emails the member.
3. Member returns the tool, which runs the Tool Return use case.
4. Inventory records the return.

Questions:
- Do some members prefer SMS?
- How long after the due time should staff get involved?
- Where does Notification Service get member contact details?

**User (simulated):** Yes, members pick email or SMS. Escalate to staff after a configurable
number of hours; I don't know the number yet. Notification Service gets contact info synced
from the member database every night.

**Claude:** I'll put the escalation delay in as `[ESCALATION_HOURS]` and the nightly sync as
an assumption. Member Database only feeds that sync and takes no action in this flow, so it
stays off this use case's Actors.

*(Self-check: numbering 1-6 with no gaps; Shop Staff acts only in E5 and is listed; SMS is
an alternate path (A4) and a bounced email is an exception path (E4) from the same step,
which the A/E prefixes keep apart; Post-Condition(s) cover the single exit, plus the extra
log entry when E5 runs. Passed.)*

**Claude:** Full use case: `02b-overdue-tool-reminder.md`. Step 5 links to Tool Return,
which isn't drafted yet. Want me to draft Tool Return next so that link resolves?

**User (simulated):** Not today. That's enough for now.
