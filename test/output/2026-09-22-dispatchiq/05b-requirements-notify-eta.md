# Functional Requirements: Notify Customer of Technician ETA

| Requirement ID | Requirement | Component | Detail | Acceptance Criteria | Priority | Source |
| --- | --- | --- | --- | --- | --- | --- |
| REQ-NotifyETA-01 | DispatchIQ shall text the customer the technician's name and a live ETA when the technician starts traveling to the job. | DispatchIQ | Basic Path steps 1-3. | When a technician marks a job "en route," the customer on file receives a text with the technician's name and a calculated ETA. | TBD, pending user input | Basic Path #1-3 |
| REQ-NotifyETA-02 | DispatchIQ shall log every ETA notification as sent. | DispatchIQ | Basic Path step 5. | Every successful notification has a corresponding sent-log entry. | TBD, pending user input | Basic Path #5 |
| REQ-NotifyETA-03 | DispatchIQ shall retry a failed SMS send exactly once, and if the retry also fails, alert the Dispatcher directly rather than only logging the failure. | DispatchIQ | Exception Path A. | A failed send is retried once; if the retry fails, the Dispatcher receives a direct alert, not just a log entry, and the notification is logged as failed, not sent. | TBD, pending user input | Exception Path A |

## Gaps flagged, not invented

- `[RETRY_DELAY]`: the use case's Open Issues/Notes flags that the wait time before the retry attempt isn't specified. No requirement above invents a value.

## CSV export

```csv
Summary,Description,Issue Type,Priority,Labels,Epic Link,Acceptance Criteria,Source
"DispatchIQ shall text the customer the technician's name and a live ETA when the technician starts traveling to the job.","Basic Path steps 1-3.",Story,TBD,NotifyETA,,"When a technician marks a job en route, the customer on file receives a text with the technician's name and a calculated ETA.","Basic Path #1-3"
"DispatchIQ shall log every ETA notification as sent.","Basic Path step 5.",Story,TBD,NotifyETA,,"Every successful notification has a corresponding sent-log entry.","Basic Path #5"
"DispatchIQ shall retry a failed SMS send exactly once, and if the retry also fails, alert the Dispatcher directly rather than only logging the failure.","Exception Path A.",Story,TBD,NotifyETA,,"A failed send is retried once; if the retry fails, the Dispatcher receives a direct alert, not just a log entry, and the notification is logged as failed, not sent.","Exception Path A"
```
