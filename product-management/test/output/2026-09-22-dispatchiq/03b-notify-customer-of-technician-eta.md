## Use Case: Notify Customer of Technician ETA

The system texts the customer a live ETA once their technician starts traveling to the job.

**Assumptions**
- The job is assigned to a technician (see [Use Case: Auto-Route a New Job](03a-auto-route-a-new-job.md)).
- The customer's phone number is on file and opted in to SMS.

**Actors**
- Technician: Starts traveling to the job, triggering the notification.
- DispatchIQ: Calculates the ETA and sends the text.
- Customer: Receives the ETA text.

**Trigger(s)**
- Technician starts traveling to a job.

**Basic Path**

| Step | Actor | Action |
| --- | --- | --- |
| 1. | Technician | Marks the job as "en route" |
| 2. | DispatchIQ | Calculates the current ETA based on technician location and drive time |
| 3. | DispatchIQ | Sends a text to the customer with the technician's name and ETA |
| 4. | Customer | Receives the text |
| 5. | DispatchIQ | Logs the notification as sent |
| | | END OF USE CASE |

**Alternate Paths**

- No alternate paths identified for this use case.

**Exception Paths**

- Exception Path (from Basic Path #3): SMS delivery fails
  3. DispatchIQ: Attempts to send the text and receives a delivery failure from the SMS provider.
  4. DispatchIQ: Retries the send once.
  5. DispatchIQ: If the retry also fails, flags the notification as failed and alerts the Dispatcher directly, not just a log entry, since a failed customer notification is the core value proposition failing.
  6. End of use case.

**Post-Condition(s)**
- Basic Path exit: The customer has received an ETA text, and the notification is logged as sent.
- Exception Path A exit: The notification is logged as failed, and the Dispatcher has been alerted directly rather than left to discover it from a log.

**Open Issues/Notes**
- `[RETRY_DELAY]`: how long to wait before the retry attempt isn't specified.
- This exception path traces directly to the PR/FAQ's Internal FAQ, which names silent SMS failure as the single biggest risk to the product. The requirement to alert the Dispatcher directly, not just log the failure, comes straight from that.
