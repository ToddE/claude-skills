## Use Case: Route Unclaimed Surplus to Food Bank

PlotShare flags an unclaimed surplus listing to the garden's food bank contact once its claim window expires.

**Assumptions**
- The garden is onboarded to PlotShare, including a designated Food Bank Contact.
- A surplus listing exists (see [Use Case: List Surplus Produce](03a-list-surplus-produce.md)) and has not been claimed (see [Use Case: Claim a Surplus Listing](03b-claim-surplus-listing.md)).

**Actors**
- PlotShare App: Tracks each listing's claim window and triggers the food bank notification.
- Food Bank Contact: The person at the food bank who receives flagged listings and arranges pickup.

**Basic Path**

| Step | Actor | Action |
| --- | --- | --- |
| 1. | PlotShare App | Detects that a surplus listing's claim window has expired without being claimed |
| 2. | PlotShare App | Marks the listing as unclaimed |
| 3. | PlotShare App | Sends the listing's details to Food Bank Contact |
| 4. | Food Bank Contact | Receives the flagged listing |
| 5. | PlotShare App | Marks the listing as routed to the food bank |
| | | END OF USE CASE |

**Alternate Paths**

- No alternate paths identified for this use case.

**Exception Paths**

- Exception Path (from Basic Path #3): PlotShare App cannot reach Food Bank Contact
  3. PlotShare App: Fails to deliver the notification to Food Bank Contact.
  4. PlotShare App: Retries the notification and logs the failure for manual follow-up if retries are exhausted.
  5. Use case continues at Basic Path #4.

**Post-Condition(s)**
- The surplus listing is marked as routed to the food bank, and Food Bank Contact has received its details.

**Open Issues/Notes**
- `[RETRY_COUNT]`: how many notification retries happen before escalating to a garden coordinator isn't specified yet.
