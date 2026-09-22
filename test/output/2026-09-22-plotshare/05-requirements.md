# Functional Requirements: Claim a Surplus Listing

| Requirement ID | Requirement | Component | Detail | Acceptance Criteria | Priority | Source |
| --- | --- | --- | --- | --- | --- | --- |
| REQ-ClaimSurplusListing-01 | PlotShare App shall let a member claim an unclaimed, unexpired surplus listing. | PlotShare App | Basic Path steps 1-4. | Selecting "Claim" on a valid listing marks it claimed by the selecting member. | TBD, pending user input | Basic Path #1-4 |
| REQ-ClaimSurplusListing-02 | PlotShare App shall notify the original lister when their listing is claimed, and remove it from the surplus board. | PlotShare App | Basic Path steps 5-6. | Other Member receives a notification, and the listing no longer appears on the board, immediately after a successful claim. | TBD, pending user input | Basic Path #5-6 |
| REQ-ClaimSurplusListing-03 | PlotShare App shall resolve simultaneous claim attempts on the same listing in favor of whichever claim was processed first, and inform the losing claimant. | PlotShare App | Alternate Path A. | When two claims race, only the first-processed claim succeeds; the other member is told the listing was just claimed. | TBD, pending user input | Alternate Path A |
| REQ-ClaimSurplusListing-04 | PlotShare App shall prevent a claim on a listing whose claim window has expired, and inform the member it's been routed to the food bank contact. | PlotShare App | Exception Path A. | Attempting to claim an expired listing fails, and the member sees a message naming the food bank routing. | TBD, pending user input | Exception Path A |

## Gaps flagged, not invented

- `[CLAIM_WINDOW]`: the use case's Open Issues/Notes flags that the claim window length isn't specified. No requirement above invents a value; this needs to be answered before REQ-ClaimSurplusListing-04 can be fully specified.

## CSV export

```csv
Summary,Description,Issue Type,Priority,Labels,Epic Link,Acceptance Criteria,Source
"PlotShare App shall let a member claim an unclaimed, unexpired surplus listing.","Basic Path steps 1-4.",Story,TBD,ClaimSurplusListing,,"Selecting Claim on a valid listing marks it claimed by the selecting member.","Basic Path #1-4"
"PlotShare App shall notify the original lister when their listing is claimed, and remove it from the surplus board.","Basic Path steps 5-6.",Story,TBD,ClaimSurplusListing,,"Other Member receives a notification, and the listing no longer appears on the board, immediately after a successful claim.","Basic Path #5-6"
"PlotShare App shall resolve simultaneous claim attempts on the same listing in favor of whichever claim was processed first, and inform the losing claimant.","Alternate Path A.",Story,TBD,ClaimSurplusListing,,"When two claims race, only the first-processed claim succeeds; the other member is told the listing was just claimed.","Alternate Path A"
"PlotShare App shall prevent a claim on a listing whose claim window has expired, and inform the member it's been routed to the food bank contact.","Exception Path A.",Story,TBD,ClaimSurplusListing,,"Attempting to claim an expired listing fails, and the member sees a message naming the food bank routing.","Exception Path A"
```
