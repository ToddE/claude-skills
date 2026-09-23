## Use Case: Chef Input (Commissioning)

The chef commissions a freshly made menu item by associating its RFID-tagged plates with
that item in Kaiten IQ.

**Assumptions**
- All appropriate menu items are loaded.
- RFID reader is connected and operational.
- Each plate has a unique RFID tag.
- Location Identity is set for each restaurant location when Kaiten IQ is installed.
- Kaiten IQ is running and displaying the Chef Interface.
- Kaiten IQ is actively scanning the chef workspace for RFID tags.

**Actors**
- Chef: Kitchen staff member preparing menu items and commissioning them to the belt via
  the Chef Interface.
- Kaiten IQ: The platform, including the RFID reader, Chef Interface, and Live Inventory.

**Trigger(s)**
- Chef has made the menu item and wishes to commission it for the belt and timer.

**Basic Path**

| Step | Actor | Action |
| --- | --- | --- |
| 1. | Kaiten IQ | Presents a list of menu items and active updates regarding Live Inventory (see Chef Interface) |
| 2. | Chef | Prepares the menu item and places it on the appropriate colored plates |
| 3. | Chef | Places plates on the workspace |
| 4. | Chef | Touches the picture and/or description of the menu item on the touch screen |
| 5. | Kaiten IQ | Determines which RFID tags are in the chef's workspace |
| 6. | Kaiten IQ | Associates the RFID tags in the workspace with the menu item the chef touched |
| 7. | Kaiten IQ | Displays the number of RFID tags associated and the plate/menu description (e.g. "8 purple plates scanned with Spider Roll") |
| 8. | Kaiten IQ | Asks the chef to confirm the scan |
| 9. | Chef | Confirms the scan |
| 10. | Kaiten IQ | Writes the RFID UIDs, their menu item association, and a "born on" timestamp to Live Inventory |
| | | END OF USE CASE |

**Alternate Paths**

- No alternate paths identified for this use case.

**Exception Paths**

- Exception Path (from Basic Path #5): Kaiten IQ does not see any RFID tags to associate
  5. Kaiten IQ: Does not see any RFID tags and cannot associate any UIDs with the menu item.
  6. Kaiten IQ: Notifies the chef and asks the chef to take corrective action (confirm plates
     are in the workspace, confirm RFID antennas are working, etc.).
  7. Chef: Acknowledges the message.
  8. Use case continues at Basic Path #1.

- Exception Path (from Basic Path #9): Chef does not confirm the scan
  9. Chef: Indicates an error in the scan (the number or type of plates does not match).
  10. Kaiten IQ: Suggests corrective actions.
  11. Chef: Acknowledges the message.
  12. Chef: Makes any necessary changes.
  13. Use case continues at Basic Path #4.

**Post-Condition(s)**
- Live Inventory contains a new record associating the RFID UIDs with the menu item and a
  "born on" timestamp.

**Open Issues/Notes**
- **Chef commissioning approach:** should plates be provisioned before or after the menu item
  is placed on them? Provisioning first requires logic for re-commissioning plates that go
  unpopulated; commissioning at time-of-use risks more scanning errors.
  - **Proposed Resolution:** dedicated plate-holders at each station to prevent over-scanning,
    or having the Chef Interface reflect all scanned plates and letting the chef pick a color
    (without picking a quantity) to associate with the menu item.
- This use case's RFID UID, menu item association, and "born on" timestamp are the input
  [Use Case: Automatic Freshness Pull](#automatic-freshness-pull) depends on to calculate
  elapsed belt time, and the input [Use Case: Checkout Plate Tally](#checkout-plate-tally)
  depends on for each plate's price tier at billing.
