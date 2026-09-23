## Use Case: Automatic Freshness Pull

Kaiten IQ detects that a circulating plate has reached its freshness threshold and has
Floor Staff remove it from the belt before a guest can take it.

**Assumptions**
- The plate's RFID UID, menu item, and "born on" timestamp are already recorded in Live
  Inventory (see [Use Case: Chef Input (Commissioning)](#chef-input-commissioning)).
- Fixed-position RFID antennas along the belt are connected and operational.
- Each menu item category has a configured freshness threshold (e.g. nigiri at 60 minutes,
  a mayonnaise-based roll at 30 minutes).
- The Floor Staff Interface is running and reachable by floor staff on shift.

**Actors**
- Kaiten IQ: The platform, including the belt antennas, Live Inventory, and the Floor Staff
  Interface.
- Floor Staff: Front-of-house staff member who retrieves flagged plates from the belt and
  confirms their removal.

**Trigger(s)**
- Kaiten IQ determines a circulating plate's elapsed time since its "born on" timestamp has
  reached its menu item category's freshness threshold.

**Basic Path**

| Step | Actor | Action |
| --- | --- | --- |
| 1. | Kaiten IQ | Reads the RFID tags of plates passing each fixed belt antenna on a continuous cycle |
| 2. | Kaiten IQ | Calculates each read plate's elapsed time since its "born on" timestamp |
| 3. | Kaiten IQ | Detects a plate whose elapsed time has reached its menu item category's freshness threshold |
| 4. | Kaiten IQ | Flags the plate and displays its last-read antenna position on the Floor Staff Interface |
| 5. | Floor Staff | Retrieves the flagged plate from the belt near the indicated position |
| 6. | Floor Staff | Scans the retrieved plate at the Floor Staff Interface to confirm removal |
| 7. | Kaiten IQ | Marks the plate's Live Inventory record as removed, with a "freshness" reason code and a removed-at timestamp |
| | | END OF USE CASE |

**Alternate Paths**

- Alternate Path (from Basic Path #1): Floor Staff removes a plate for a visible quality
  defect before it reaches its freshness threshold
  1. Floor Staff: Notices a plate with a visible quality defect (e.g. a shifted topping or a
     spill) while it is still within its freshness window.
  2. Floor Staff: Removes the plate from the belt and scans it at the Floor Staff Interface,
     selecting "Quality removal" as the reason.
  3. Kaiten IQ: Marks the plate's Live Inventory record as removed, with a "quality" reason
     code and a removed-at timestamp, distinct from a freshness-based removal.
  4. Use case continues at Basic Path #1.

**Exception Paths**

- Exception Path (from Basic Path #4): Flagged plate is gone from the belt before Floor
  Staff retrieves it
  4. Kaiten IQ: Flags the plate and displays its last-read antenna position on the Floor
     Staff Interface.
  5. Floor Staff: Searches the indicated position and does not find the flagged plate (a
     guest took it before Floor Staff arrived).
  6. Floor Staff: Reports the plate as not found at the Floor Staff Interface.
  7. Kaiten IQ: Marks the plate's Live Inventory record as removed, with an
     "uncollected" reason code and a removed-at timestamp equal to its last confirmed
     antenna read.
  8. Kaiten IQ: Logs the discrepancy for manager review.
  9. End of use case (for this plate; belt monitoring continues independently at Basic
     Path #1 for every other circulating plate).

- Exception Path (from Basic Path #1): Kaiten IQ fails to read an expected RFID tag for a
  plate physically present on the belt (a damaged or detached tag)
  1. Kaiten IQ: Detects a mismatch between the plate count a belt antenna's camera observes
     and the number of RFID tags successfully read at that antenna.
  2. Kaiten IQ: Flags a read-gap alert and notifies Floor Staff to visually inspect that belt
     segment.
  3. Floor Staff: Visually inspects the segment and either locates a plate with no readable
     tag or confirms no discrepancy.
  4. Floor Staff: If a plate is found, manually removes it and logs the removal at the Floor
     Staff Interface with an estimated elapsed time; if no discrepancy is confirmed, clears
     the read-gap alert.
  5. Use case continues at Basic Path #1.

**Post-Condition(s)**
- **Basic Path exit:** Live Inventory shows the plate's RFID UID with status "removed –
  freshness," a removed-at timestamp, and the plate no longer counts as active circulating
  inventory.
- **Alternate Path exit (quality removal):** Live Inventory shows the plate's RFID UID with
  status "removed – quality," a removed-at timestamp, and the plate no longer counts as
  active circulating inventory.
- **Exception Path A exit (uncollected):** Live Inventory shows the plate's RFID UID with
  status "removed – uncollected," a removed-at timestamp equal to its last confirmed antenna
  read, and a discrepancy log entry exists for manager review.
- **Exception Path B exit (read gap):** Either Live Inventory shows the affected plate's RFID
  UID with a manually logged removal and an estimated elapsed time, or the read-gap alert is
  cleared with no removal record change, depending on Floor Staff's inspection finding.

**Open Issues/Notes**
- Freshness thresholds are configured per menu item category, not per plate; whether a
  licensee operator can set thresholds tighter than Ebisu Kaiten-Zushi's own defaults (e.g.
  for a hot, humid location) for the same menu item category is unconfirmed.
- Exception Path A assumes a guest taking an already-flagged plate is an acceptable outcome
  worth logging rather than blocking; whether Kaiten IQ should instead alert Floor Staff in
  real time as the flagged plate approaches a guest's seat is a question for [Use Case:
  Checkout Plate Tally](#checkout-plate-tally) to help answer, since that use case's
  Exception Path B handles a guest presenting an already-flagged plate at billing.
