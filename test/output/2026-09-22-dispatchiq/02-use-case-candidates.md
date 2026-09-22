# Initiative: DispatchIQ

**What is it:** DispatchIQ, a scheduling and dispatch tool for home-service businesses
(plumbing, electrical, HVAC) with 2-15 technicians, that auto-routes new jobs to the
nearest available technician and automatically texts customers a live ETA.

**Goals:**
- Auto-route a new job to the technician who can get there soonest, accounting for drive
  time and current job load.
- Automatically notify the customer by text when a technician is on the way, with a live
  ETA, without a dispatcher making a call.
- Give technicians a mobile view of their route instead of a printed sheet.
- Hit the pilot's core proof point: measurably fewer no-shows and missed appointments,
  not just working software.
- Charge per technician seat plus SMS usage in a way that stays profitable per account,
  not just on average.

**Out of scope (for this initiative):** invoicing and payment processing, technician
payroll, customer-facing self-scheduling (customers don't book directly yet).

## Candidate Use Cases

| Name | Summary | Rough Actors | Rough Trigger |
| --- | --- | --- | --- |
| Auto-Route a New Job | The system assigns a newly created job to the technician who can reach it soonest. | Dispatcher, DispatchIQ, Technician | Dispatcher creates a new job. |
| Notify Customer of Technician ETA | The system texts the customer a live ETA once a technician is en route. | DispatchIQ, Technician, Customer | Technician starts traveling to a job. |
| Re-Route on Technician Delay | The system detects a technician is running behind and updates the customer's ETA automatically. | DispatchIQ, Technician, Customer | |
| Technician Views Daily Route | A technician opens the mobile view to see their assigned jobs in order. | Technician, DispatchIQ | Technician starts their shift. |
| Onboard a Shop to DispatchIQ | A new customer's technicians, service area, and SMS settings get configured before their first job. | Dispatcher, DispatchIQ | Shop signs up for the pilot or a paid plan. |
| Dispatcher Reassigns a Job Manually | A dispatcher overrides the automatic routing to assign a job to a specific technician. | Dispatcher, DispatchIQ, Technician | Dispatcher disagrees with the automatic assignment. |

## Notes for review

- "Re-Route on Technician Delay" has no independent trigger since it's a continuation of
  either "Auto-Route a New Job" or "Notify Customer of Technician ETA" once a technician is
  already en route; confirm that's intentional rather than a sign it should be folded into
  one of those two instead of standing alone.
- "Auto-Route a New Job" and "Dispatcher Reassigns a Job Manually" are closely related;
  confirm they should stay separate (automatic vs. manual assignment are genuinely
  different flows with different actors driving the decision) rather than merged into one
  use case with an alternate path.
- Actor names are consistent across every row: "Dispatcher," "Technician," "Customer," and
  "DispatchIQ" always mean the same thing.
