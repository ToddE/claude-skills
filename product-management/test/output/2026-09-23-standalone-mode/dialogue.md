# Dialogue: Standalone Mode Verification (five downstream skills, cold)

Purpose of this run: every prior example run in `product-management/test/output/` chains
`working-backwards-prfaq` into the five downstream skills, so each downstream skill's own
"don't re-ask if already given" rule fires and its own intake is skipped. Every one of those
runs demonstrates the chained path; none demonstrates the standalone path each skill's own
SKILL.md also documents. This run exists only to test that standalone path: five separate,
unrelated cold invocations, one per downstream skill, with no shared context between them
and no PR/FAQ or upstream use case behind any of them.

## Before intake: tool-call attempt, and why the rest of this run is manual

Before running anything by hand, this run called the real `Skill` tool directly:
`Skill(skill: "use-case-discovery")`. It returned `Unknown skill: use-case-discovery`. This
is not the same failure mode as the previously documented `working-backwards-prfaq`
collision (where a same-named skill from a different plugin loads silently and answers
instead of erroring) — here the tool refused outright, meaning none of the five
`product-management` use-case skills are registered as callable in this session at all, not
even under a colliding name. Since the task anticipated this general class of problem and
prescribed the same fallback for it ("read that skill's actual current SKILL.md/references
files directly ... and execute that documented procedure by hand instead, exactly like the
continental-circuits and ebisu-kikata runs did"), that is what every one of the five sections
below does: each skill's current `SKILL.md` and `references/format.md` (and, for
architect-review, both persona files) were read in full first, and its documented workflow
was then followed step by step, by hand, self-answering as a plausible user.

Each of the five scenarios below is deliberately unrelated to the others and to every
existing example in this repo (food pantry volunteer scheduling, warehouse returns
processing, a public library hold pickup, a two-factor-authentication reminder banner, and a
two-person budgeting app), specifically so nothing here could be mistaken for implicit
chaining or shared context.

---

## use-case-discovery (standalone)

Scenario: cold, no PR/FAQ, no prior use case. Followed `use-case-discovery/SKILL.md` Step 1
(Understand the initiative) as a real, one-question-at-a-time interview, since the user's
opening message gave only a one-line premise, not a full initiative description.

**User (simulated):** I'm building a volunteer shift-scheduling tool for a nonprofit food
pantry. What use cases do I need?

**Claude:** Before I break this into use cases, I need a bit more on the initiative itself.
First: what is it, in a sentence or two beyond "shift scheduling"? Specifically, is this
replacing something the pantry already uses (a spreadsheet, a paper sign-up sheet, a group
text), and is it a public-facing website, an app, or something a coordinator manages by
hand and volunteers just see?

**User (simulated):** It replaces a shared spreadsheet our volunteer coordinator currently
edits by hand. It's a small web app: the coordinator publishes open shifts for a given week,
and volunteers log in to see and claim open shifts themselves instead of texting the
coordinator to be added to a slot.

**Claude:** Got it. Second: who and what is involved, roughly? I don't need final actor
names yet, just the rough set of people, apps, and systems that will show up across the
use cases.

**User (simulated):** Volunteers who claim shifts, the Coordinator who publishes and manages
the schedule, the scheduling app itself, and some kind of notifier since we'd want text or
email reminders and alerts — we haven't picked a vendor for that yet.

**Claude:** Third: what does this need to accomplish? Give me a short list of goals, the
same shape as a "Solution Objectives" list — not tied to any one flow yet.

**User (simulated):**
- Get the coordinator out of manually tracking who's working which shift in a spreadsheet.
- Let volunteers self-serve: claim, cancel, or swap a shift without texting the coordinator.
- Make sure every shift has at least a minimum headcount before it starts, and flag it to
  the coordinator if it's short-staffed close to start time.
- Track logged volunteer hours, since we have to report total volunteer hours annually for
  a grant we receive.

**Claude:** Last one: what's explicitly out of scope for this pass? Worth being direct about
this so the candidate list doesn't sprawl.

**User (simulated):** Paid-staff scheduling is out — this is volunteers only. Volunteer
background-check processing is out too; that's handled by a separate system already.
Donation and food inventory tracking are also out; totally separate tool.

**Claude:** That's enough to decompose. Confirming my understanding: this is a self-serve
shift-scheduling web app for one food pantry's volunteer program, replacing a
coordinator-maintained spreadsheet, with goals around reducing coordinator manual work,
volunteer self-service, minimum-headcount enforcement, and grant-reportable hour tracking.
Paid staff, background checks, and inventory are all out of scope. Here's the candidate list
before I draft any of these in full.

| Name | Summary | Rough Actors | Rough Trigger |
| --- | --- | --- | --- |
| Volunteer Signup & Profile Creation | A new volunteer creates an account and profile so they can start claiming shifts. | Volunteer, Scheduler | Volunteer visits the signup page. |
| Coordinator Publishes Shift Schedule | The Coordinator creates and publishes a week's open shifts for volunteers to claim. | Coordinator, Scheduler | Coordinator starts a new week's schedule. |
| Volunteer Claims a Shift | A volunteer browses open shifts and claims one for themselves. | Volunteer, Scheduler, Notifier | Volunteer opens the open-shifts list. |
| Volunteer Swaps or Cancels a Claimed Shift | A volunteer who can no longer work a claimed shift cancels it or swaps it with another volunteer. | Volunteer, Scheduler, Notifier | Volunteer selects an upcoming claimed shift. |
| Automatic Under-Staffed Shift Escalation | Scheduler detects a shift is still under minimum headcount close to its start time and alerts the Coordinator. | Scheduler, Coordinator, Notifier | Scheduled: nightly (or hourly, near start time) check comparing claimed headcount against each shift's minimum. |
| Volunteer Hours Export for Grant Reporting | The Coordinator exports logged volunteer hours for a date range to support annual grant reporting. | Coordinator, Scheduler | Coordinator requests an hours report. |

A few things worth confirming before I draft any of these in full:
- I ordered the table roughly setup → primary use → support/error flows, which becomes the
  suggested drafting order if we hand these to use-case-uml.
- "Automatic Under-Staffed Shift Escalation" is the one candidate whose trigger isn't a user
  action; it's a scheduled/internal check. I filled in that trigger explicitly rather than
  leaving Rough Trigger blank, because the format convention treats a blank trigger as a
  signal that a candidate might really be a continuation of another candidate (like
  the format reference's own "Subscriber Session" example) — and this one isn't a
  continuation of anything, it's genuinely its own externally-triggered (time-triggered)
  flow. Leaving it blank would have wrongly suggested it should be merged into "Coordinator
  Publishes Shift Schedule" or "Volunteer Claims a Shift," and it shouldn't be.
- "Scheduler" and "Notifier" are used consistently everywhere they appear — confirm those are
  the right two names before I draft, since use-case-uml will enforce this consistency across
  the eventual documents.

Does this list match what you need, and should "Scheduler" and "Notifier" stay as separate
actors, or is the notifier really just a feature of the same app?

**User (simulated):** This matches. Keep Scheduler and Notifier separate — we're planning to
use a third-party SMS/email API for notifications, not build that ourselves, so it really is
a distinct system the Scheduler calls out to.

**Claude:** Good, that's confirmed then (see `use-case-discovery-output.md` for the final
candidate list with that actor split). Next step would normally be handing this off to
use-case-uml to draft each candidate in full, one at a time or as a batch. I checked my
current list of available skills and use-case-uml isn't active in this session, so I can't
hand off to a live invocation of it here — it's part of this same repo
(`github.com/ToddE/claude-skills`), so you'd install/enable it there to continue this
specific thread. For this test run, use-case-uml's standalone behavior is being verified
completely separately, on an unrelated scenario, specifically so it isn't a continuation of
this one.

---

## use-case-uml (standalone)

Scenario: cold, no use-case-discovery candidate handed in, no PR/FAQ. Followed
`use-case-uml/SKILL.md` Step 1 (Gather the flow) as a real interview, since the user's
opening message was a one-line flow description, not a fully specified flow.

**User (simulated):** Write a use case for how a returned online order gets restocked at a
warehouse.

**Claude:** This isn't fully specified yet, so let me ask a few questions before drafting.
First: title and one-sentence purpose aside, what has to already be true before this flow
starts — what assumptions am I working with? For example, has a return already been
authorized (an RMA issued) before the package physically arrives, or does this flow cover
that too?

**User (simulated):** A return has already been authorized online before this starts — the
customer requested the return and got an RMA number and a shipping label from a separate
returns-authorization flow that's out of scope here. This use case starts when the physical
package shows up at the warehouse dock.

**Claude:** Good, that also answers my trigger question — the package's physical arrival.
Second: who and what takes action in this flow? I need every actor, not just the obvious
one.

**User (simulated):** A Returns Clerk who receives and opens the package at the dock, a
Quality Inspector who checks item condition, our Warehouse Management System (WMS) which
looks up the RMA and tracks inventory counts, and a Stocker who physically moves the item to
its shelf location. Small warehouses have the same person do Returns Clerk and Stocker, but
they're different responsibilities.

**Claude:** Third, walk me through the happy path — the ordered sequence from the package
arriving to the item being back in sellable inventory.

**User (simulated):** Clerk scans the RMA barcode on the package. WMS looks up the original
order and what item(s) should be inside. Clerk opens the package and checks the contents
against what WMS expects. Clerk routes the item to the Quality Inspector. Inspector checks
the item's condition. Inspector marks it sellable in WMS. WMS adds it back to sellable
inventory count for that SKU and location, and prints a putaway label with a bin location.
Stocker moves the item to that bin. WMS marks the RMA as restocked and complete.

**Claude:** Last: what are the known ways this can go differently or fail? I'm thinking at
least: the RMA barcode not matching anything in WMS, the box containing the wrong item, and
the item failing inspection. Are there others, and should all three of those be captured?

**User (simulated):** Those three are the real ones we see. RMA not found: barcode is
damaged or was never actually issued, that happens more than you'd think. Wrong item in the
box: customer returned something else by mistake. Failed inspection: item is damaged, used
beyond resale condition, or missing accessories — that one doesn't come back to the
sellable path at all, it goes to a write-off/liquidation process that's handled outside this
system, so from this use case's point of view it's a dead end, not a rejoin.

**Claude:** That's enough to draft. One more check before I write it: for "wrong item in the
box," does that dead-end too, or does someone get a chance to correct it and continue?

**User (simulated):** It doesn't dead-end — the clerk logs what was actually received and a
separate customer-service ticket gets opened, but the physical item itself, once identified,
still goes through the same inspection and restock path. So it rejoins the flow, just a
couple steps later than a normal match would.

**Claude:** Understood, drafting now. See `use-case-uml-output.md` for the full document.

**Claude (Step 3 self-check, run against the draft before presenting):**
- Every listed Actor (Returns Clerk, WMS, Quality Inspector, Stocker) appears in the Basic
  Path, not only in a branch — confirmed.
- Basic Path ends with the literal `| | | END OF USE CASE |` row — confirmed.
- The Alternate Path (wrong item in box) references a real step number and ends "Use case
  continues at Basic Path #N" since it rejoins, per what you told me. Both Exception Paths
  (RMA not found, failed inspection) reference real step numbers; RMA-not-found rejoins
  after a corrective step, failed inspection ends with "End of use case." since you confirmed
  that's a genuine dead end for this system, not a rejoin.
- No two consecutive Basic Path rows are the same actor doing the same non-branchable
  action — checked step-by-step, none collide.
- Post-Condition(s) given separately for the Basic Path exit and the failed-inspection
  terminal exit, since those are the two distinct end states.
- Section order matches the spec exactly (Assumptions, Actors, Trigger(s), Basic Path,
  Alternate Paths, Exception Paths, Post-Condition(s), Open Issues/Notes) — no invented
  section names.

**Claude:** Draft's ready (`use-case-uml-output.md`). Want me to add another alternate/
exception path, or since this is a standalone test I'd normally also offer use-case-test-cases
and use-case-requirements here — checking my available skills list, neither is active in this
session, so I'm noting that rather than assuming they're ready to use; both are part of this
same repo.

---

## use-case-test-cases (standalone)

Scenario: cold-pasted, fully-written use case with no memory of authorship, per the skill's
own documented standalone entry point ("paste it, or point me to the file"). The use case
below (Library Book Hold Pickup) was freshly written for this test and does not appear
anywhere else in this repo.

**User (simulated):** Here's a completed use case. Can you write test cases for it?

> **Use Case: Library Book Hold Pickup**
>
> A patron picks up a book they placed on hold once it has arrived at the library and been
> shelved for pickup.
>
> **Assumptions**
> - Patron placed the hold online and received a "ready for pickup" notification.
> - The book has physically arrived at the branch and been shelved on the hold shelf.
>
> **Actors**
> - Patron: The library member picking up their held item.
> - Library Staff: Front-desk staff member checking out held items.
> - Catalog System: The library's holds and circulation system.
>
> **Trigger(s)**
> - Patron arrives at the library to pick up a held item.
>
> **Basic Path**
>
> | Step | Actor | Action |
> | --- | --- | --- |
> | 1. | Patron | Approaches the hold shelf desk and gives their name or library card |
> | 2. | Library Staff | Searches Catalog System for the patron's ready holds |
> | 3. | Catalog System | Displays the patron's ready-for-pickup holds |
> | 4. | Library Staff | Retrieves the physical book from the hold shelf |
> | 5. | Library Staff | Scans the book's barcode to check it out to the patron |
> | 6. | Catalog System | Marks the hold as fulfilled and the item as checked out to the patron |
> | 7. | Library Staff | Hands the book to the patron |
> | | | END OF USE CASE |
>
> **Alternate Paths**
> - Alternate Path (from Basic Path #2): Patron's hold has expired past the pickup window
>   2. Catalog System: Shows the hold status as "expired."
>   3. Library Staff: Informs the patron the hold expired and offers to re-place it.
>   4. Patron: Requests a new hold.
>   5. Catalog System: Creates a new hold record for the patron at the back of the queue.
>   6. End of use case.
>
> **Exception Paths**
> - Exception Path (from Basic Path #4): Book is missing from the shelf despite the system
>   showing it ready
>   4. Library Staff: Cannot locate the book on the hold shelf.
>   5. Library Staff: Marks the item as "missing" in Catalog System.
>   6. Catalog System: Flags the hold for staff follow-up and keeps the hold active.
>   7. Library Staff: Informs the patron and offers to search the branch network or wait for
>      staff follow-up.
>   8. End of use case.
>
> **Post-Condition(s)**
> - **Basic Path exit:** Catalog System shows the item checked out to the patron and the
>   original hold marked fulfilled.
> - **Alternate Path A exit:** Catalog System shows a new hold record for the patron in queue;
>   the original hold record shows status "expired."
> - **Exception Path A exit:** Catalog System shows the item status as "missing"; the original
>   hold remains active and flagged for staff follow-up.
>
> **Open Issues/Notes**
> - None identified.

**Claude:** This use case has everything I need: Assumptions, Actors, a Basic Path ending in
`END OF USE CASE`, one Alternate Path and one Exception Path each referencing real step
numbers, and Post-Condition(s) written as checkable states for all three exit points, not a
narrative recap. I don't need to stop and ask for anything before drafting test cases.

Enumerating the paths to cover, in order: Basic Path, then Alternate Path A, then Exception
Path A. That's three test cases. See `use-case-test-cases-output.md` for the full set.

**Claude (Step 4 self-check, run before presenting):**
- Each of the three paths has exactly one test case; none needed additional edge-case
  coverage since the user didn't ask for extra.
- Each Expected Result is copied from the matching Post-Condition(s) bullet, not
  paraphrased or invented: TC-01 uses the Basic Path exit bullet verbatim, TC-02 the
  Alternate Path A exit bullet, TC-03 the Exception Path A exit bullet.
- Test Case IDs (`TC-LibraryHoldPickup-01/02/03`) are unique and sequential.
- No test case invents a system behavior the use case doesn't state — for instance, TC-03
  doesn't assume the missing book ever gets found, since the use case's Exception Path A
  ends at "End of use case" without saying so.

---

## use-case-requirements (standalone, Mode B)

Scenario: cold, no use case, no PR/FAQ. Followed `use-case-requirements/SKILL.md`'s Mode B
three-stage interview directly, one question at a time.

**User (simulated):** I want functional requirements for a feature idea, no use case yet: a
two-factor-authentication reminder banner that nags users who haven't enabled 2FA.

**Claude:** No use case and no PR/FAQ exists for this yet, so I'll run the short Mode B
interview rather than asking you to go write a use case first. Stage 1: what is it, in one
or two sentences?

**User (simulated):** A persistent but dismissible banner shown inside the web app's
dashboard that reminds a logged-in user to enable two-factor authentication on their account
if they haven't already, with a direct link to the 2FA setup page.

**Claude:** Stage 2: who is this for, specifically, and what problem does it solve? "Users"
isn't specific enough — push for something concrete.

**User (simulated):** Specifically, our existing paid-tier customers who signed up before we
made 2FA available and never went back to turn it on. The problem: our security team flagged
that a meaningful share of account-takeover support tickets trace back to accounts with no
2FA enabled, and those users have no ongoing prompt to fix that; the only current mention of
2FA is buried in account settings, which nobody visits unprompted.

**Claude:** Stage 3, and this is the one to slow down on: what does it actually need to do?
I want the concrete behaviors and constraints, the edge cases you already know about, and
anything explicitly out of scope. To start: when exactly does the banner show, and when does
it stop?

**User (simulated):** It shows on dashboard load for any logged-in user whose account
doesn't have 2FA enabled. It stops permanently for that user the moment they enable 2FA —
that's the real success condition, not just dismissing the banner.

**Claude:** And if the user dismisses the banner without enabling 2FA — does it come back,
and on what schedule?

**User (simulated):** Yes, it should come back. If dismissed, don't show it again for 14
days, then resume showing it on every dashboard load until either 2FA gets enabled or it's
dismissed again, restarting the 14-day snooze each time.

**Claude:** Any cap on how naggy this can get, or a point where it escalates or changes
tone, and is there any user segment that should never see it even without 2FA — a free tier,
an enterprise SSO tier where 2FA is enforced differently, anything like that?

**User (simulated):** No escalation, just the same banner every time it's due. One real
exclusion: accounts provisioned through our enterprise SSO integration should never see this
banner at all, since their organization's identity provider handles the equivalent of 2FA
outside our system entirely — showing this banner to them would be actively wrong, not just
unnecessary.

**Claude:** Last for this stage: what happens if enabling 2FA fails partway through (say,
they start setup from the banner link but abandon it), and is dismissal itself logged
anywhere, or just held as per-user state?

**User (simulated):** If they abandon setup, nothing special happens — the banner just
resumes on its normal schedule since 2FA still isn't enabled, same as any other dismiss. I
don't think we need to log every dismissal individually anywhere durable beyond the
snooze-until state; that's more instrumentation than this needs right now. And out of scope
entirely: this feature doesn't touch the 2FA setup flow itself, only the banner that points
to it.

**Claude:** Recap before I generate requirements: a dashboard banner shown to logged-in,
non-SSO users without 2FA enabled, linking to 2FA setup; permanently stops once 2FA is
enabled; on dismissal, snoozes for 14 days and then resumes, restarting the snooze on each
subsequent dismissal; SSO accounts are excluded entirely; no escalation behavior; no durable
dismissal logging beyond the snooze state; the 2FA setup flow itself is out of scope. Does
that match, and one thing I still need from you directly since I can't infer it: what
priority should these carry — do you use MoSCoW, High/Medium/Low, P0–P3, something else?

**User (simulated):** That's right. Use High/Medium/Low.

**Claude:** Generating the requirements list now. See `use-case-requirements-output.md`.

**Claude (self-check before presenting):**
- Every requirement's Source cites a specific interview stage/topic (never a use case
  reference, since this is Mode B) — confirmed across all six.
- Coverage: every distinct Stage 3 answer produced at least one requirement — the show
  condition, the permanent-stop condition, the snooze/resume behavior, the SSO exclusion,
  the no-escalation behavior, and the abandoned-setup non-behavior. Nothing silently
  dropped.
- No requirement duplicates another; the "resumes after abandoned setup" behavior was folded
  into the same requirement as the snooze/resume behavior rather than written as its own
  near-duplicate row, since it's the same rule ("still no 2FA → resume on schedule") applied
  to a different cause.
- Acceptance Criteria came directly from what the user stated (14 days, "permanently," "never
  shows") rather than invented; none needed a bracket placeholder here since the user gave
  concrete numbers and rules for everything asked.
- Priority was asked for directly rather than guessed; user gave High/Medium/Low as the
  scale, so Priority values use that scale, not an invented MoSCoW/P0–P3 label.

**Claude:** Table's ready. Want this exported as a generic CSV for Jira import, GitHub
Issues markdown, or both?

**User (simulated):** Both, please.

**Claude:** Both exports are in `use-case-requirements-output.md`, after the table.

---

## architect-review (standalone)

Scenario: cold, nothing beyond a one-line idea — no PR/FAQ, no use case, no requirements.
Followed `architect-review/SKILL.md` Step 1 exactly as written for this case ("if nothing
exists beyond a one-line idea, ask the user to describe it... say plainly the recommendation
is less grounded").

**User (simulated):** Give me an architecture review for this idea: a personal budgeting app
that syncs balances across two people's phones.

**Claude:** Nothing exists yet beyond this one line — no PR/FAQ, no use case, no functional
requirements. I can still give you a recommendation from just a description, but I'll say
plainly in the header that it's less grounded than a review built on real requirements would
be. Before I draft anything, a few quick questions so "syncs balances" means something
concrete: is this reading real bank balances (something like a Plaid-style connection), or
manual entry that both people update? And is there a team behind this, or is it just you
right now?

**User (simulated):** Real bank balances where possible — pulled from a Plaid-style
read-only bank connection — plus manual entry for cash, since not every account can be
linked. It's two partners tracking shared accounts and a couple of shared credit cards, and
right now it's just me building it, no team, evenings-and-weekends side project, targeting
iOS and Android.

**Claude:** One more: how real-time does "syncs" need to be? Does a shared card charge need
to show up on the other partner's phone within seconds, or is checking balances once or a
few times a day close enough?

**User (simulated):** A few times a day is genuinely fine. The annoying thing today is
manually texting each other "hey I just spent $40 on groceries," not that we need
sub-minute sync.

**Claude:** That's enough to work with. I have two personas available: The Pragmatic
Modulith Architect (cloud-agnostic, ships an integrated modulith, owns the stack) and The
Assembler (buys managed vendor services over building, optimizes for time-to-first-customer).
Want one specific persona's take, or should I run both and let you compare?

**User (simulated):** Run both.

**Claude:** Drafting both now, each fully separate, grounded in what you just told me (solo
builder, two-user shared-account budgeting, bank-linked plus manual balances, a
few-times-a-day sync tolerance, no team to operate infrastructure). See
`architect-review-output.md` for both full write-ups.

**Claude (Step 5 self-check, run against both drafts before presenting):**
- `clean-style` is available in my current skill list; applying its spirit directly (no
  filler, no dramatic language, direct) rather than a live invocation, since this check is
  fast enough to do by reading the draft against the rule set from memory of the skill's own
  stated purpose: checked both drafts for em-dashes, hedge-padding, and contrastive framing —
  none found, no changes needed.
- Each major recommendation in both drafts traces to either something the user said in this
  conversation (two users, bank-linked plus manual entry, no team, tolerant sync latency) or
  to the persona's own stated philosophy (buy-over-build for The Assembler, modulith-first for
  The Pragmatic Modulith Architect) — confirmed, none invented.
- Both outputs are fully separate artifacts, not blended into one voice — confirmed, each has
  its own header and its own full section set.
- Bracket placeholders used for anything only the user could specify and didn't: neither
  draft needed one, since the clarifying questions above covered the load-bearing unknowns
  (data source, team size, latency tolerance); both drafts flag `[COMPLIANCE_REQUIREMENT]`
  only as an open question, not a placeholder standing in for a recommendation, since no
  actual compliance need was stated either way.

**Claude:** Both recommendations are ready. Since two personas ran, I can also run an
opt-in debate between them, grounded in a short intake about your budget, operational
appetite, and risk tolerance, if you want to see where they'd actually disagree rather than
just reading two independent takes. Want that?

**User (simulated):** Not for this test — two independent takes is what I wanted to see.

**Claude:** Understood, leaving it there. The debate stays available if you want it later;
per the skill's own instructions it's opt-in and never runs automatically.
