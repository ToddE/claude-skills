## Use Case: List Surplus Produce

A garden member lists extra produce on the surplus board for other members to claim.

**Assumptions**
- The garden is onboarded to PlotShare.
- Member is a registered member of the garden.

**Actors**
- Member: The garden member listing surplus produce.
- PlotShare App: Records the listing and starts its claim window.

**Trigger(s)**
- Member has more produce than they can use and wants to offer it to others.

**Basic Path**

| Step | Actor | Action |
| --- | --- | --- |
| 1. | Member | Opens the surplus board and selects "List Surplus" |
| 2. | Member | Enters what they're offering and roughly how much |
| 3. | PlotShare App | Validates that the listing has a description and quantity |
| 4. | PlotShare App | Publishes the listing to the surplus board |
| 5. | PlotShare App | Starts the listing's claim window |
| 6. | PlotShare App | Notifies other garden members that a new surplus listing is available |
| | | END OF USE CASE |

**Alternate Paths**

- No alternate paths identified for this use case.

**Exception Paths**

- Exception Path (from Basic Path #3): Member submits a listing with no description or quantity
  3. PlotShare App: Determines the listing is missing a description or quantity.
  4. PlotShare App: Tells Member what's missing.
  5. Use case continues at Basic Path #2.

**Post-Condition(s)**
- A new surplus listing exists on the board, within its claim window, and other garden members have been notified.

**Open Issues/Notes**
- Should a member be able to edit or cancel a listing after publishing it, before it's claimed? Not covered by this use case as scoped.
