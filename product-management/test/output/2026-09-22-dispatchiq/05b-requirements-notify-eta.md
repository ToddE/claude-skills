# Functional Requirements: Notify Customer of Technician ETA

| Requirement ID | Requirement | Component | Detail | Acceptance Criteria | Priority | Source |
| --- | --- | --- | --- | --- | --- | --- |
| REQ-NotifyETA-01 | DispatchIQ shall calculate a live ETA based on the technician's current location and drive time when they start traveling to a job. | DispatchIQ | Basic Path step 2. | An ETA calculation exists for the job within seconds of the technician marking it "en route." | TBD, pending user input | Basic Path #2 |
| REQ-NotifyETA-02 | DispatchIQ shall text the customer the technician's name and the calculated ETA. | DispatchIQ | Basic Path step 3. | The customer on file receives a text containing the technician's name and the ETA calculated in REQ-NotifyETA-01. | TBD, pending user input | Basic Path #3 |
| REQ-NotifyETA-03 | DispatchIQ shall log every ETA notification as sent. | DispatchIQ | Basic Path step 5. | Every successful notification has a corresponding sent-log entry. | TBD, pending user input | Basic Path #5 |
| REQ-NotifyETA-04 | DispatchIQ shall retry a failed SMS send exactly once. | DispatchIQ | Exception Path A, steps 3-4. | A failed send produces exactly one retry attempt, no more. | TBD, pending user input | Exception Path A |
| REQ-NotifyETA-05 | DispatchIQ shall, if the retry also fails, log the notification as failed and alert the Dispatcher directly rather than only logging the failure. | DispatchIQ | Exception Path A, step 5. | After a failed retry, the notification is logged as failed and the Dispatcher receives a direct alert naming the job, not just a log entry. | TBD, pending user input | Exception Path A |

## Gaps flagged, not invented

- `[RETRY_DELAY]`: the use case's Open Issues/Notes flags that the wait time before the retry attempt isn't specified. REQ-NotifyETA-04 doesn't invent a value.

## CSV export

```csv
Summary,Description,Issue Type,Priority,Labels,Epic Link,Acceptance Criteria,Source
"DispatchIQ shall calculate a live ETA based on the technician's current location and drive time when they start traveling to a job.","Basic Path step 2.",Story,TBD,NotifyETA,,"An ETA calculation exists for the job within seconds of the technician marking it en route.","Basic Path #2"
"DispatchIQ shall text the customer the technician's name and the calculated ETA.","Basic Path step 3.",Story,TBD,NotifyETA,,"The customer on file receives a text containing the technician's name and the ETA calculated in REQ-NotifyETA-01.","Basic Path #3"
"DispatchIQ shall log every ETA notification as sent.","Basic Path step 5.",Story,TBD,NotifyETA,,"Every successful notification has a corresponding sent-log entry.","Basic Path #5"
"DispatchIQ shall retry a failed SMS send exactly once.","Exception Path A, steps 3-4.",Story,TBD,NotifyETA,,"A failed send produces exactly one retry attempt, no more.","Exception Path A"
"DispatchIQ shall, if the retry also fails, log the notification as failed and alert the Dispatcher directly rather than only logging the failure.","Exception Path A, step 5.",Story,TBD,NotifyETA,,"After a failed retry, the notification is logged as failed and the Dispatcher receives a direct alert naming the job, not just a log entry.","Exception Path A"
```
