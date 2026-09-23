# Test Cases: Notify Customer of Technician ETA

| Test Case ID | Title | Covers | Preconditions | Steps | Expected Result |
| --- | --- | --- | --- | --- | --- |
| TC-NotifyETA-01 | Successful ETA notification | Basic Path | Job is assigned to a technician; customer's phone number is on file and opted in. | 1. Technician marks the job "en route." 2. Observe the customer's phone. | The customer has received an ETA text, and the notification is logged as sent. |
| TC-NotifyETA-02 | SMS delivery fails on send and on retry | Exception Path A | Same as TC-01, except the customer's number rejects delivery (invalid number or carrier rejection). | 1. Technician marks the job "en route." 2. Observe the send attempt fail. 3. Observe the retry attempt fail. | The notification is logged as failed, and the Dispatcher is alerted directly, not left to discover it from a log. This is the use case's terminal Post-Condition for this exit point, not a rejoin state, since Exception Path A ends the use case rather than looping back. |
