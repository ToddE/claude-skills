# Use Case: Warehouse Return Restock

A returns clerk and quality inspector process a customer's returned item back into sellable
warehouse inventory once it physically arrives at the dock.

Produced standalone by `use-case-uml`, cold, no use-case-discovery candidate handed in. See
`dialogue.md` for the full Step 1 interview this was derived from.

**Assumptions**
- The return has already been authorized online and an RMA number plus shipping label
  issued to the customer (a separate returns-authorization flow, out of scope here).
- The Warehouse Management System (WMS) has a record of the RMA and the expected item(s).

**Actors**
- Returns Clerk: Warehouse staff member who receives and opens returned packages at the dock.
- WMS: The Warehouse Management System, tracking RMAs, inventory counts, and bin locations.
- Quality Inspector: Warehouse staff member who checks returned item condition.
- Stocker: Warehouse staff member who physically moves an item to its shelf/bin location.

**Trigger(s)**
- A returned package physically arrives at the warehouse dock.

**Basic Path**

| Step | Actor | Action |
| --- | --- | --- |
| 1. | Returns Clerk | Scans the RMA barcode on the returned package at intake |
| 2. | WMS | Looks up the original order and expected item(s) for that RMA |
| 3. | Returns Clerk | Opens the package and matches its contents against the expected item(s) |
| 4. | Returns Clerk | Routes the matched item to the Quality Inspector |
| 5. | Quality Inspector | Inspects the item's condition |
| 6. | Quality Inspector | Marks the item as sellable in WMS |
| 7. | WMS | Increments sellable inventory count for that SKU at that location |
| 8. | WMS | Prints a putaway label with a bin location |
| 9. | Stocker | Moves the item to the labeled bin location |
| 10. | WMS | Marks the RMA as restocked and complete |
| | | END OF USE CASE |

**Alternate Paths**

- Alternate Path (from Basic Path #3): Package contents don't match the expected item
  3. Returns Clerk: Finds the package contains a different item than WMS expected for this
     RMA.
  4. Returns Clerk: Logs what was actually received in WMS and flags the RMA for a
     customer-service ticket (opened outside this system).
  5. Returns Clerk: Routes the actually-received item to the Quality Inspector.
  6. Use case continues at Basic Path #5.

**Exception Paths**

- Exception Path (from Basic Path #2): RMA barcode not found in WMS
  2. WMS: Returns no matching RMA record for the scanned barcode.
  3. Returns Clerk: Sets the package aside and logs it as an unmatched return for manual
     research.
  4. End of use case.

- Exception Path (from Basic Path #6): Item fails quality inspection
  6. Quality Inspector: Marks the item as damaged, used beyond resale condition, or missing
     accessories, not sellable.
  7. WMS: Routes the item to the write-off/liquidation process (handled outside this
     system).
  8. End of use case.

**Post-Condition(s)**
- **Basic Path exit:** WMS shows increased sellable inventory count for the item's SKU at the
  bin location the putaway label specified, and the RMA record shows status "restocked
  complete."
- **Exception Path A exit (RMA not found):** WMS has a logged unmatched-return record for the
  scanned barcode; no inventory count changed.
- **Exception Path B exit (failed inspection):** WMS shows the item routed to
  write-off/liquidation, not added to sellable inventory; the RMA record shows status
  reflecting the write-off routing rather than "restocked complete."

**Open Issues/Notes**
- The customer-service ticket opened in Alternate Path A (wrong item received) is described
  as happening "outside this system" — worth confirming during implementation whether WMS
  needs to record a reference to that ticket, or whether that link lives entirely in the
  customer-service tool.

---

**Step 3 self-check (run before presenting, see `dialogue.md` for the full reasoning):**
Actors and Basic Path stay in sync; Basic Path ends with the literal `END OF USE CASE` row;
the Alternate Path and both Exception Paths each reference a real step number and end with
either a rejoin or "End of use case." as appropriate; no two consecutive Basic Path rows
repeat the same actor doing the same non-branchable action; Post-Condition(s) given
separately for all three exit points; section order matches the format spec exactly.
