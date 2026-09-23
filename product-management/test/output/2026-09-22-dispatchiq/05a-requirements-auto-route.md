# Functional Requirements: Auto-Route a New Job

| Requirement ID | Requirement | Component | Detail | Acceptance Criteria | Priority | Source |
| --- | --- | --- | --- | --- | --- | --- |
| REQ-AutoRoute-01 | DispatchIQ shall calculate estimated drive time from each available technician's current location to the job address. | DispatchIQ | Basic Path step 2. | Every technician marked available has a calculated drive-time estimate to the new job's address before assignment logic runs. | TBD, pending user input | Basic Path #2 |
| REQ-AutoRoute-02 | DispatchIQ shall determine which technician can arrive soonest without exceeding their current job load. | DispatchIQ | Basic Path step 3. | Given drive-time estimates and current job loads, exactly one technician under the job-load limit is selected as soonest-arriving. | TBD, pending user input | Basic Path #3 |
| REQ-AutoRoute-03 | DispatchIQ shall assign the job to the determined technician and add it to their route. | DispatchIQ | Basic Path step 4. | The job record shows the selected technician as assigned, and the job appears on that technician's route. | TBD, pending user input | Basic Path #4 |
| REQ-AutoRoute-04 | DispatchIQ shall break a tie between technicians with equal soonest arrival by job load, not by an arbitrary order. | DispatchIQ | Alternate Path A. | When two or more technicians tie on arrival time, the job goes to whichever has the lighter current job load. | TBD, pending user input | Alternate Path A |
| REQ-AutoRoute-05 | DispatchIQ shall flag a job as unassigned when no technician can meet the requested time window. | DispatchIQ | Exception Path A, step 4 (flagging). | When no technician's drive time and schedule can meet the window, the job record is marked unassigned rather than given a forced assignment. | TBD, pending user input | Exception Path A |
| REQ-AutoRoute-06 | DispatchIQ shall notify the Dispatcher when a job is flagged unassigned. | DispatchIQ | Exception Path A, step 4 (notification). | The Dispatcher receives a notification naming the specific job that couldn't be assigned. | TBD, pending user input | Exception Path A |

## Gaps flagged, not invented

- `[JOB_LOAD_LIMIT]`: the use case's Open Issues/Notes flags that the threshold for "too loaded to take another job" isn't specified. No requirement above invents a number; REQ-AutoRoute-02 depends on it.

## CSV export

```csv
Summary,Description,Issue Type,Priority,Labels,Epic Link,Acceptance Criteria,Source
"DispatchIQ shall calculate estimated drive time from each available technician's current location to the job address.","Basic Path step 2.",Story,TBD,AutoRoute,,"Every technician marked available has a calculated drive-time estimate to the new job's address before assignment logic runs.","Basic Path #2"
"DispatchIQ shall determine which technician can arrive soonest without exceeding their current job load.","Basic Path step 3.",Story,TBD,AutoRoute,,"Given drive-time estimates and current job loads, exactly one technician under the job-load limit is selected as soonest-arriving.","Basic Path #3"
"DispatchIQ shall assign the job to the determined technician and add it to their route.","Basic Path step 4.",Story,TBD,AutoRoute,,"The job record shows the selected technician as assigned, and the job appears on that technician's route.","Basic Path #4"
"DispatchIQ shall break a tie between technicians with equal soonest arrival by job load, not by an arbitrary order.","Alternate Path A.",Story,TBD,AutoRoute,,"When two or more technicians tie on arrival time, the job goes to whichever has the lighter current job load.","Alternate Path A"
"DispatchIQ shall flag a job as unassigned when no technician can meet the requested time window.","Exception Path A, step 4 (flagging).",Story,TBD,AutoRoute,,"When no technician's drive time and schedule can meet the window, the job record is marked unassigned rather than given a forced assignment.","Exception Path A"
"DispatchIQ shall notify the Dispatcher when a job is flagged unassigned.","Exception Path A, step 4 (notification).",Story,TBD,AutoRoute,,"The Dispatcher receives a notification naming the specific job that couldn't be assigned.","Exception Path A"
```
