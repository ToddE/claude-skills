# Test Cases: Automatic Freshness Pull

### TC-FreshnessPull-01: Plate reaches freshness threshold and is pulled

**Covers:** Basic Path

**Preconditions:**
- A plate's RFID UID, menu item, and "born on" timestamp are recorded in Live Inventory
  (from TC-ChefInput-01).
- Belt antennas are operational; the plate's menu item category has a configured freshness
  threshold.
- The Floor Staff Interface is running.

**Steps:**
1. Allow the plate to circulate on the belt until its elapsed time reaches its category's
   freshness threshold.
2. Observe Kaiten IQ flag the plate and display its last-read antenna position on the Floor
   Staff Interface.
3. Retrieve the flagged plate from the indicated position.
4. Scan the retrieved plate at the Floor Staff Interface to confirm removal.

**Expected Result:**
- Live Inventory shows the plate's RFID UID with status "removed – freshness," a removed-at
  timestamp, and the plate no longer counts as active circulating inventory.

### TC-FreshnessPull-02: Floor Staff removes a plate for a quality defect before threshold

**Covers:** Alternate Path A

**Preconditions:**
- A commissioned plate is circulating on the belt, within its freshness window.
- The plate has a visible quality defect.

**Steps:**
1. Notice the plate's visible quality defect while it is still within its freshness window.
2. Remove the plate from the belt.
3. Scan the plate at the Floor Staff Interface, selecting "Quality removal" as the reason.

**Expected Result:**
- Live Inventory shows the plate's RFID UID with status "removed – quality," a removed-at
  timestamp, and the plate no longer counts as active circulating inventory.

### TC-FreshnessPull-03: Flagged plate is gone before Floor Staff retrieves it

**Covers:** Exception Path A

**Preconditions:**
- Kaiten IQ has flagged a plate and displayed its last-read antenna position on the Floor
  Staff Interface.

**Steps:**
1. Search the indicated antenna position for the flagged plate.
2. Confirm the plate is not there (a guest took it before retrieval).
3. Report the plate as not found at the Floor Staff Interface.

**Expected Result:**
- Live Inventory shows the plate's RFID UID with status "removed – uncollected," a removed-at
  timestamp equal to its last confirmed antenna read, and a discrepancy log entry exists for
  manager review.

### TC-FreshnessPull-04: RFID tag can't be read for a plate physically on the belt

**Covers:** Exception Path B

**Preconditions:**
- A commissioned, tagged plate is physically on the belt.
- The plate's tag is damaged or detached so its antenna reads don't match the belt camera's
  observed plate count at that antenna.

**Steps:**
1. Observe Kaiten IQ flag a read-gap alert and notify Floor Staff to inspect the belt
   segment.
2. Visually inspect the segment and locate the plate with no readable tag.
3. Manually remove the plate and log the removal at the Floor Staff Interface with an
   estimated elapsed time.

**Expected Result:**
- Live Inventory shows a manually logged removal record for the affected plate with an
  estimated elapsed time, and the read-gap alert is cleared.
