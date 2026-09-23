## Use Case: Claim a Surplus Listing

A garden member claims another member's surplus produce listing before its claim window expires.

**Assumptions**
- The garden is onboarded to PlotShare.
- A surplus listing already exists on the board (see [Use Case: List Surplus Produce](03a-list-surplus-produce.md)).
- The claiming member is a registered member of the same garden.

**Actors**
- Member: The garden member attempting to claim a surplus listing.
- Other Member: The garden member who originally listed the surplus produce.
- PlotShare App: Displays listings, processes claims, and enforces the claim window.

**Trigger(s)**
- Member sees an open surplus listing they want.

**Basic Path**

| Step | Actor | Action |
| --- | --- | --- |
| 1. | Member | Browses the surplus board and finds a listing |
| 2. | Member | Selects "Claim" on the listing |
| 3. | PlotShare App | Checks whether the listing is still within its claim window and unclaimed |
| 4. | PlotShare App | Marks the listing as claimed by Member |
| 5. | PlotShare App | Notifies Other Member that their listing was claimed |
| 6. | PlotShare App | Removes the listing from the surplus board |
| | | END OF USE CASE |

**Alternate Paths**

- Alternate Path (from Basic Path #3): Two members attempt to claim the same listing at nearly the same time
  3. PlotShare App: Detects that another member's claim was already processed for this listing moments earlier.
  4. PlotShare App: Tells Member the listing was just claimed by someone else.
  5. Use case continues at Basic Path #1.

**Exception Paths**

- Exception Path (from Basic Path #3): The claim window has already expired
  3. PlotShare App: Determines the listing's claim window has expired.
  4. PlotShare App: Tells Member the listing is no longer available and has been routed to the food bank contact.
  5. Use case continues at Basic Path #1.

**Post-Condition(s)**
- The surplus listing is marked claimed by Member, removed from the surplus board, and Other Member has been notified. (Alternate Path A and Exception Path A both rejoin Basic Path #1 rather than ending the use case, so neither gets its own terminal Post-Condition; see the paths themselves for what's true at the point of rejoin.)

**Open Issues/Notes**
- `[CLAIM_WINDOW]`: how long a listing stays open before it expires and routes to the food bank contact isn't specified yet. Needs a value before this ships. See [Use Case: Route Unclaimed Surplus to Food Bank](03c-route-unclaimed-surplus-to-food-bank.md) for what happens when it does.
