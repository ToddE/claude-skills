# Initiative: PlotShare

**What is it:** PlotShare, a Parks Department app that replaces paper sign-up sheets and
group texts with a shared plot schedule and a surplus-produce board that routes unclaimed
listings to a food bank contact.

**Goals:**
- Give every garden member a plot schedule they can check and claim without relying on a
  physical sign-up sheet or a group text.
- Let members list surplus produce for neighbors, and route anything unclaimed to a food
  bank contact automatically.
- Support members without a smartphone with a printed schedule generated from the app.
- Hit pilot-season success measures: 70% active schedule usage, 200 lbs of surplus routed,
  fewer scheduling disputes than the prior season.

**Out of scope (for this initiative):** payment or billing (there is none), multi-city
rollout logistics beyond the pilot, integration with external gardening or weather apps.

## Candidate Use Cases

| Name | Summary | Rough Actors | Rough Trigger |
| --- | --- | --- | --- |
| Claim a Plot Slot | A member claims an open slot on the shared schedule for their plot. | Member, PlotShare App | Member wants to reserve time on their plot. |
| List Surplus Produce | A member lists extra produce for other members to claim. | Member, PlotShare App | Member has more produce than they can use. |
| Claim a Surplus Listing | A member claims another member's surplus listing before it expires or gets routed to the food bank. | Member, PlotShare App, Other Member | Member sees an open surplus listing they want. |
| Route Unclaimed Surplus to Food Bank | The app flags an unclaimed surplus listing to the garden's food bank contact once its claim window expires. | PlotShare App, Food Bank Contact | |
| Generate Printed Schedule | A member without a smartphone gets a paper copy of the current schedule generated from the app. | Garden Coordinator, PlotShare App | Garden Coordinator needs a printed schedule for members without phones. |
| Onboard a Garden to PlotShare | The Parks Department sets up a new garden's plots, membership, and food bank contact in the app ahead of a season. | Parks Department, Garden Coordinator, PlotShare App | Parks Department approves a garden for rollout. |

## Notes for review

- "Route Unclaimed Surplus to Food Bank" has no independent trigger since it's a
  continuation of "List Surplus Produce" once a claim window expires; confirm that's
  intentional rather than a sign the two should be one longer use case.
- "Member" and "Other Member" both refer to the same actor type; using "Other Member" only
  in "Claim a Surplus Listing" is intentional, to distinguish the lister from the claimant
  within that one flow, not a naming inconsistency across the document.
- "Onboard a Garden to PlotShare" is a setup flow that every other candidate implicitly
  depends on (a garden has to exist in the app before members can use it). Confirm whether
  it should be drafted first, ahead of the member-facing flows, even though it's less
  interesting from a product standpoint.
