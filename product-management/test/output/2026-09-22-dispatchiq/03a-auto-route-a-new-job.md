## Use Case: Auto-Route a New Job

The system assigns a newly created job to the technician who can reach it soonest, without exceeding their current job load.

**Assumptions**
- The shop is onboarded to DispatchIQ (technicians and service area configured).
- At least one technician is registered.

**Actors**
- Dispatcher: Creates the job and reviews the routing outcome.
- DispatchIQ: Calculates drive time and current job load, and assigns the job.
- Technician: Receives the assigned job on their route.

**Trigger(s)**
- Dispatcher creates a new job.

**Basic Path**

| Step | Actor | Action |
| --- | --- | --- |
| 1. | Dispatcher | Enters the job details (address, service type, requested time window) |
| 2. | DispatchIQ | Calculates estimated drive time from each available technician's current location to the job address |
| 3. | DispatchIQ | Determines which technician can arrive soonest without exceeding their current job load |
| 4. | DispatchIQ | Assigns the job to that technician and adds it to their route |
| 5. | Technician | Sees the new job appear on their route |
| 6. | Dispatcher | Sees the assignment confirmed on the schedule board |
| | | END OF USE CASE |

**Alternate Paths**

- Alternate Path (from Basic Path #3): Two technicians have equally soonest arrival times
  3. DispatchIQ: Determines two or more technicians tie for soonest arrival.
  4. DispatchIQ: Assigns the job to the technician with the lighter current job load, breaking the tie.
  5. Use case continues at Basic Path #4.

**Exception Paths**

- Exception Path (from Basic Path #3): No technician can reach the job within the requested time window
  3. DispatchIQ: Determines no technician can arrive within the requested window.
  4. DispatchIQ: Flags the job as unassigned and notifies the Dispatcher.
  5. Dispatcher: Manually adjusts the time window or reassigns another job to make room.
  6. Use case continues at Basic Path #2.

**Post-Condition(s)**
- The job is assigned to a technician, added to their route, and visible to the Dispatcher on the schedule board.

**Open Issues/Notes**
- `[JOB_LOAD_LIMIT]`: how many jobs a technician can have before they're considered too loaded to take another isn't specified yet.
