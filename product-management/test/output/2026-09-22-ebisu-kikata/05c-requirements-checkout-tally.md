# Functional Requirements: Checkout Plate Tally

Basic Path step 3 ("reads every RFID tag in range and retrieves each plate's price tier")
looks like one requirement, but it's two distinct effects with two different failure modes:
"the reader missed a tag" is a different bug from "the reader read the tag but pulled the
wrong price tier from Live Inventory," so it splits into REQ-01 and REQ-02. Basic Path step
8 (Cashier processes payment) gets no Kaiten IQ requirement: payment processing itself is
explicitly out of scope for this initiative (see `02-use-case-candidates.md`'s scope note);
Kaiten IQ's role ends at producing a confirmed tally. The Alternate Path's override
recalculation and audit log (steps 9) merge into one requirement, since a single override
action always produces both effects together as one testable, atomic outcome, the same
merge rule the format spec uses for a single externally observable handoff.

| Requirement ID | Requirement | Component | Detail | Acceptance Criteria | Priority | Source |
| --- | --- | --- | --- | --- | --- | --- |
| REQ-CheckoutTally-01 | Kaiten IQ shall read every RFID tag within range of the checkout reader when a plate stack is presented for checkout. | Kaiten IQ | Basic Path step 3 (reading). | Every physically present, undamaged RFID tag on the checkout reader is included in the read set for that checkout. | Must | Basic Path #3 |
| REQ-CheckoutTally-02 | Kaiten IQ shall retrieve the price tier for each read RFID tag from Live Inventory. | Kaiten IQ | Basic Path step 3 (lookup). | Every read RFID UID resolves to the price tier recorded for it at commissioning, with no default or guessed tier substituted. | Must | Basic Path #3 |
| REQ-CheckoutTally-03 | Kaiten IQ shall tally plate count by price tier and calculate the subtotal. | Kaiten IQ | Basic Path step 4. | The displayed subtotal equals the sum of each price tier's plate count multiplied by its configured price. | Must | Basic Path #4 |
| REQ-CheckoutTally-04 | Kaiten IQ shall display the itemized tally and subtotal to the Cashier before payment is processed. | Kaiten IQ | Basic Path step 5. | The tally screen shows a per-tier breakdown and subtotal matching REQ-CheckoutTally-03's calculation before the Cashier can proceed to payment. | Must | Basic Path #5 |
| REQ-CheckoutTally-05 | Kaiten IQ shall close each tallied plate's Live Inventory record with a "sold" status, sale timestamp, and transaction ID once payment is confirmed. | Kaiten IQ | Basic Path step 9, Post-Condition (Basic Path exit). | Every plate included in a paid tally shows a "sold" status, a sale timestamp, and the transaction ID in Live Inventory. | Must | Basic Path #9, Post-Condition (Basic Path exit) |
| REQ-CheckoutTally-06 | Kaiten IQ shall let the Cashier apply a manual override (add or remove a plate) to a checkout tally in progress. | Kaiten IQ | Alternate Path A, step 8. | A Cashier override action changes the tallied plate set without requiring the guest to re-present their plates to the reader. | Should | Alternate Path A |
| REQ-CheckoutTally-07 | Kaiten IQ shall recalculate the subtotal and log the override with the Cashier's ID whenever a manual override is applied. | Kaiten IQ | Alternate Path A, step 9, Post-Condition (Alternate Path exit). | An applied override produces both a revised subtotal reflecting the change and an override log entry naming the Cashier's ID and the affected plate. | Should | Alternate Path A, Post-Condition (Alternate Path exit) |
| REQ-CheckoutTally-08 | Kaiten IQ shall detect a mismatch between the Cashier-entered physical plate count and the number of RFID tags successfully read. | Kaiten IQ | Exception Path A, steps 3-4 (detection). | A checkout where the physical count and the read-tag count differ is flagged before the tally is finalized. | Must | Exception Path A |
| REQ-CheckoutTally-09 | Kaiten IQ shall prompt the Cashier to rescan in smaller batches when a read-count mismatch is detected. | Kaiten IQ | Exception Path A, step 4 (prompt). | The Cashier sees a rescan prompt naming the mismatch within the same checkout session as the detection in REQ-CheckoutTally-08. | Should | Exception Path A |
| REQ-CheckoutTally-10 | Kaiten IQ shall confirm a full match between the physical plate count and the tags read before proceeding to tally the subtotal. | Kaiten IQ | Exception Path A, step 6, rejoin to Basic Path #4. | The subtotal calculation (REQ-CheckoutTally-03) doesn't run for a checkout still showing a count mismatch. | Must | Exception Path A |
| REQ-CheckoutTally-11 | Kaiten IQ shall detect when a read RFID tag's Live Inventory record already shows a "removed" status. | Kaiten IQ | Exception Path B, step 3. | Every read tag whose Live Inventory record shows any "removed" status is identified before it's added to the tally. | Must | Exception Path B |
| REQ-CheckoutTally-12 | Kaiten IQ shall flag a previously-removed plate to the Cashier for a freshness confirmation before billing. | Kaiten IQ | Exception Path B, step 4. | The Cashier sees a "previously flagged for removal" prompt for every plate REQ-CheckoutTally-11 detects, before that plate is priced. | Must | Exception Path B |
| REQ-CheckoutTally-13 | Kaiten IQ shall record the Cashier's sell/discount/decline resolution against a previously-removed plate's Live Inventory record, and include it in the tally at the resolved price only if sold or discounted. | Kaiten IQ | Exception Path B, steps 6-7, Post-Condition (Exception Path B exit). | A declined plate is excluded from the tally and total; a sold or discounted plate appears in the tally at its resolved price, with the resolution and Cashier ID recorded on its Live Inventory record. | Must | Exception Path B, Post-Condition (Exception Path B exit) |

## Gaps flagged, not invented

- `[DISCOUNT_POLICY]` (referenced in `03c`'s Open Issues/Notes) isn't defined; no requirement
  above assumes a specific discount amount or rule for a previously-flagged plate a Cashier
  chooses to discount rather than decline.
- Whether Kaiten IQ should alert Floor Staff or the Cashier before a flagged plate ever
  reaches a guest's table, rather than only catching it at checkout (Exception Path B), is
  flagged in both `03b` and `03c`'s Open Issues/Notes and isn't a requirement here since
  neither use case states that earlier-detection behavior today.
