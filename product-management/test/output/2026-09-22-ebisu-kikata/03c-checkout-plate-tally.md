## Use Case: Checkout Plate Tally

A guest requests the bill, and Kaiten IQ tallies their stacked plates by price tier instead
of a hand count.

**Assumptions**
- Each plate at the table has already been commissioned with a menu item, price tier, and
  "born on" timestamp (see [Use Case: Chef Input (Commissioning)](#chef-input-commissioning)).
- A checkout RFID reader is installed at the register or table-side terminal and is
  operational.
- Each price tier is mapped to a plate color and a price in Kaiten IQ's configuration.

**Actors**
- Guest: Diner who selects and eats plates from the belt, then requests the bill.
- Kaiten IQ: The platform, including the checkout RFID reader, the tally screen, and Live
  Inventory.
- Cashier: Front-of-house staff member who finalizes the bill and processes payment.

**Trigger(s)**
- Guest signals readiness to pay (presses a table call button or brings their plate stack to
  the register).

**Basic Path**

| Step | Actor | Action |
| --- | --- | --- |
| 1. | Guest | Signals readiness to pay |
| 2. | Cashier | Directs the guest to place the stacked plates on the checkout RFID reader |
| 3. | Kaiten IQ | Reads every RFID tag in range and retrieves each plate's price tier from Live Inventory |
| 4. | Kaiten IQ | Tallies plate count by price tier and calculates the subtotal |
| 5. | Kaiten IQ | Displays the itemized tally and subtotal on the tally screen |
| 6. | Cashier | Reviews the tally with the guest |
| 7. | Guest | Confirms the total is correct |
| 8. | Cashier | Processes payment for the confirmed total |
| 9. | Kaiten IQ | Closes each tallied plate's Live Inventory record with a "sold" status and the transaction ID |
| | | END OF USE CASE |

**Alternate Paths**

- Alternate Path (from Basic Path #7): Guest disputes the tally
  7. Guest: Disputes the tally, citing a specific plate discrepancy (e.g. a plate that slid
     into a neighboring stack).
  8. Cashier: Inspects the disputed plate(s) and applies a manual override at the tally
     screen to add or remove it.
  9. Kaiten IQ: Recalculates the subtotal with the override applied and logs the override
     with the Cashier's ID.
  10. Use case continues at Basic Path #6 (Cashier reviews the revised tally with the guest).

**Exception Paths**

- Exception Path (from Basic Path #3): Kaiten IQ can't read every plate in the stack
  3. Kaiten IQ: Detects a mismatch between the physical plate count the Cashier enters and
     the number of RFID tags successfully read.
  4. Kaiten IQ: Flags the discrepancy and asks the Cashier to fan out the plates or rescan
     them in smaller batches.
  5. Cashier: Rescans the plate stack in smaller batches.
  6. Kaiten IQ: Confirms a full match between the physical count and the tags read.
  7. Use case continues at Basic Path #4.

- Exception Path (from Basic Path #3): Guest presents a plate Kaiten IQ already flagged for
  removal
  3. Kaiten IQ: Reads an RFID tag whose Live Inventory record already shows a "removed"
     status (see [Use Case: Automatic Freshness Pull](#automatic-freshness-pull)), meaning
     the plate was flagged as taken off the belt before checkout.
  4. Kaiten IQ: Flags the plate to the Cashier as "previously flagged for removal, confirm
     freshness before billing."
  5. Cashier: Inspects the plate and either bills it at full price, applies a discount per
     house policy, or declines to sell it and directs the guest to select a different plate.
  6. Cashier: Enters the resolution (sell, discount, or decline) at the tally screen.
  7. Kaiten IQ: Records the resolution against the plate's Live Inventory record and, if sold
     or discounted, includes it in the tally at the resolved price.
  8. Use case continues at Basic Path #4.

**Post-Condition(s)**
- **Basic Path exit:** Live Inventory shows each tallied plate's RFID UID with a "sold"
  status, a sale timestamp, and the transaction ID; the guest's total equals the sum of the
  tallied price tiers.
- **Alternate Path exit (dispute resolved):** Same as the Basic Path exit, plus an override
  log entry on the affected plate's record naming the Cashier's ID and the disputed plate.
- **Exception Path B exit (previously flagged plate, declined):** The plate's Live Inventory
  record shows a "declined at checkout" status, a resolution timestamp, and the Cashier's ID;
  it is excluded from the guest's tally and total.

**Open Issues/Notes**
- House policy for a previously flagged plate (full price, discount, or decline) isn't
  defined yet; [DISCOUNT_POLICY] marks where a licensee operator sets its own rule.
- Whether Kaiten IQ should proactively alert the Cashier or Floor Staff before a flagged
  plate reaches a guest's table, rather than only catching it at checkout, is an open
  question that would move detection earlier in [Use Case: Automatic Freshness
  Pull](#automatic-freshness-pull).
