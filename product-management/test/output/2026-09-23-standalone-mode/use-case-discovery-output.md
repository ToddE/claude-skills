# Candidate Use Cases: FoodShare Scheduler (Volunteer Shift Scheduling)

Produced standalone by `use-case-discovery`, cold, no PR/FAQ or prior use case behind it.
See `dialogue.md` for the full Step 1 interview this was derived from.

**Initiative:** FoodShare Scheduler — a small web app that replaces a food pantry's
coordinator-maintained spreadsheet, letting volunteers self-serve claim, cancel, and swap
shifts instead of texting the coordinator.

**Goals:**
- Get the coordinator out of manually tracking who's working which shift in a spreadsheet.
- Let volunteers self-serve: claim, cancel, or swap a shift without texting the coordinator.
- Make sure every shift has at least a minimum headcount before it starts, and flag it to
  the coordinator if it's short-staffed close to start time.
- Track logged volunteer hours, since the pantry reports total volunteer hours annually for
  a grant it receives.

**Out of scope (for this pass):** paid-staff scheduling, volunteer background-check
processing (handled by a separate existing system), donation/food inventory tracking.

| Name | Summary | Rough Actors | Rough Trigger |
| --- | --- | --- | --- |
| Volunteer Signup & Profile Creation | A new volunteer creates an account and profile so they can start claiming shifts. | Volunteer, Scheduler | Volunteer visits the signup page. |
| Coordinator Publishes Shift Schedule | The Coordinator creates and publishes a week's open shifts for volunteers to claim. | Coordinator, Scheduler | Coordinator starts a new week's schedule. |
| Volunteer Claims a Shift | A volunteer browses open shifts and claims one for themselves. | Volunteer, Scheduler, Notifier | Volunteer opens the open-shifts list. |
| Volunteer Swaps or Cancels a Claimed Shift | A volunteer who can no longer work a claimed shift cancels it or swaps it with another volunteer. | Volunteer, Scheduler, Notifier | Volunteer selects an upcoming claimed shift. |
| Automatic Under-Staffed Shift Escalation | Scheduler detects a shift is still under minimum headcount close to its start time and alerts the Coordinator. | Scheduler, Coordinator, Notifier | Scheduled: periodic check comparing claimed headcount against each shift's minimum as start time approaches. |
| Volunteer Hours Export for Grant Reporting | The Coordinator exports logged volunteer hours for a date range to support annual grant reporting. | Coordinator, Scheduler | Coordinator requests an hours report. |

**Notes from review with the (simulated) user:**
- The table is ordered setup → primary use → support/error flows, the suggested drafting
  order if these are handed to use-case-uml next.
- "Automatic Under-Staffed Shift Escalation" deliberately has a filled-in Rough Trigger
  ("Scheduled: periodic check...") rather than a blank one. A blank Rough Trigger is a
  signal a candidate might really be a continuation of another candidate, and this one
  isn't — it's genuinely its own externally-triggered (time-triggered) flow, so leaving it
  blank would have wrongly suggested folding it into "Coordinator Publishes Shift Schedule"
  or "Volunteer Claims a Shift."
- "Scheduler" and "Notifier" were confirmed as separate actors: the pantry plans to use a
  third-party SMS/email API for notifications rather than building that itself, so it's a
  genuinely distinct system the Scheduler calls out to, not just a feature of the same app.
- Confirmed by the (simulated) user as final; not revised further in this pass.

**Handoff status:** use-case-uml is not active in this session's available-skills list, so no
live handoff was made. Per the skill's own instructions, that's disclosed here rather than
assumed away. use-case-uml's own standalone behavior is verified separately in this same
test run, on the unrelated warehouse-returns scenario, precisely so it isn't a continuation
of this candidate list.
