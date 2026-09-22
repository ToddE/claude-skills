# Functional Requirements: Auto-Route a New Job

| Requirement ID | Requirement | Component | Detail | Acceptance Criteria | Priority | Source |
| --- | --- | --- | --- | --- | --- | --- |
| REQ-AutoRoute-01 | DispatchIQ shall assign a new job to the technician who can arrive soonest without exceeding their current job load. | DispatchIQ | Basic Path steps 2-4. | Given valid job details and at least one available technician, the job is assigned to the technician with the shortest estimated arrival time among those under the job-load limit. | TBD, pending user input | Basic Path #2-4 |
| REQ-AutoRoute-02 | DispatchIQ shall break a tie between technicians with equal soonest arrival by job load, not by an arbitrary order. | DispatchIQ | Alternate Path A. | When two or more technicians tie on arrival time, the job goes to whichever has the lighter current job load. | TBD, pending user input | Alternate Path A |
| REQ-AutoRoute-03 | DispatchIQ shall flag a job as unassigned and notify the Dispatcher when no technician can meet the requested window, rather than force an assignment. | DispatchIQ | Exception Path A. | When no technician's drive time and schedule can meet the window, the job is marked unassigned and the Dispatcher is notified, not silently assigned to an over-committed technician. | TBD, pending user input | Exception Path A |

## Gaps flagged, not invented

- `[JOB_LOAD_LIMIT]`: the use case's Open Issues/Notes flags that the threshold for "too loaded to take another job" isn't specified. No requirement above invents a number.

## CSV export

```csv
Summary,Description,Issue Type,Priority,Labels,Epic Link,Acceptance Criteria,Source
"DispatchIQ shall assign a new job to the technician who can arrive soonest without exceeding their current job load.","Basic Path steps 2-4.",Story,TBD,AutoRoute,,"Given valid job details and at least one available technician, the job is assigned to the technician with the shortest estimated arrival time among those under the job-load limit.","Basic Path #2-4"
"DispatchIQ shall break a tie between technicians with equal soonest arrival by job load, not by an arbitrary order.","Alternate Path A.",Story,TBD,AutoRoute,,"When two or more technicians tie on arrival time, the job goes to whichever has the lighter current job load.","Alternate Path A"
"DispatchIQ shall flag a job as unassigned and notify the Dispatcher when no technician can meet the requested window, rather than force an assignment.","Exception Path A.",Story,TBD,AutoRoute,,"When no technician's drive time and schedule can meet the window, the job is marked unassigned and the Dispatcher is notified, not silently assigned to an over-committed technician.","Exception Path A"
```
