# Functional Requirements: Claim a Surplus Listing

| Requirement ID | Requirement | Component | Detail | Acceptance Criteria | Priority | Source |
| --- | --- | --- | --- | --- | --- | --- |
| REQ-ClaimSurplusListing-01 | PlotShare App shall check whether a listing is still within its claim window and unclaimed before processing a claim attempt. | PlotShare App | Basic Path step 3. | A claim attempt against an expired or already-claimed listing is rejected before any claim state is written. | TBD, pending user input | Basic Path #3 |
| REQ-ClaimSurplusListing-02 | PlotShare App shall mark a valid listing as claimed by the requesting member. | PlotShare App | Basic Path step 4. | The listing record shows the claiming member's ID and a claimed timestamp. | TBD, pending user input | Basic Path #4 |
| REQ-ClaimSurplusListing-03 | PlotShare App shall notify the original lister when their listing is claimed. | PlotShare App | Basic Path step 5. | The original lister receives a notification naming the listing and who claimed it. | TBD, pending user input | Basic Path #5 |
| REQ-ClaimSurplusListing-04 | PlotShare App shall remove a claimed listing from the surplus board. | PlotShare App | Basic Path step 6. | The listing no longer appears on the surplus board immediately after a successful claim. | TBD, pending user input | Basic Path #6 |
| REQ-ClaimSurplusListing-05 | PlotShare App shall resolve simultaneous claim attempts on the same listing in favor of whichever claim was processed first, and inform the losing claimant. | PlotShare App | Alternate Path A. | When two claims race, only the first-processed claim succeeds; the other member sees a message that the listing was just claimed. | TBD, pending user input | Alternate Path A |
| REQ-ClaimSurplusListing-06 | PlotShare App shall prevent a claim on a listing whose claim window has expired and inform the member it's been routed to the food bank contact. | PlotShare App | Exception Path A. | Attempting to claim an expired listing fails, and the member sees a message naming the food bank routing. | TBD, pending user input | Exception Path A |

## Gaps flagged, not invented

- `[CLAIM_WINDOW]`: the use case's Open Issues/Notes flags that the claim window length isn't specified. No requirement above invents a value; REQ-ClaimSurplusListing-01 and -06 both depend on it.

## CSV export

```csv
Summary,Description,Issue Type,Priority,Labels,Epic Link,Acceptance Criteria,Source
"PlotShare App shall check whether a listing is still within its claim window and unclaimed before processing a claim attempt.","Basic Path step 3.",Story,TBD,ClaimSurplusListing,,"A claim attempt against an expired or already-claimed listing is rejected before any claim state is written.","Basic Path #3"
"PlotShare App shall mark a valid listing as claimed by the requesting member.","Basic Path step 4.",Story,TBD,ClaimSurplusListing,,"The listing record shows the claiming member's ID and a claimed timestamp.","Basic Path #4"
"PlotShare App shall notify the original lister when their listing is claimed.","Basic Path step 5.",Story,TBD,ClaimSurplusListing,,"The original lister receives a notification naming the listing and who claimed it.","Basic Path #5"
"PlotShare App shall remove a claimed listing from the surplus board.","Basic Path step 6.",Story,TBD,ClaimSurplusListing,,"The listing no longer appears on the surplus board immediately after a successful claim.","Basic Path #6"
"PlotShare App shall resolve simultaneous claim attempts on the same listing in favor of whichever claim was processed first, and inform the losing claimant.","Alternate Path A.",Story,TBD,ClaimSurplusListing,,"When two claims race, only the first-processed claim succeeds; the other member sees a message that the listing was just claimed.","Alternate Path A"
"PlotShare App shall prevent a claim on a listing whose claim window has expired and inform the member it's been routed to the food bank contact.","Exception Path A.",Story,TBD,ClaimSurplusListing,,"Attempting to claim an expired listing fails, and the member sees a message naming the food bank routing.","Exception Path A"
```
