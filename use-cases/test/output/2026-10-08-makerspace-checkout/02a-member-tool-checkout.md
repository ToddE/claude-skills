### Use Case: Member Tool Checkout

A member checks out a tool at the kiosk so the makerspace knows who has it and when it is
due back.

**Assumptions**
- Member has a badge registered in Member Database
- Member Database holds each member's membership status and completed safety trainings
- Each tool has a unique RFID tag registered in Inventory, with a required training (or
  none) and a loan period
- Kiosk is online and showing the badge-in screen

**Actors**
- Member: A Foundry Makerspace member borrowing a tool.
- Kiosk: The self-service checkout station with a badge reader and RFID scanner.
- Member Database: The system of record for memberships and completed safety trainings.
- Inventory: The system of record for tools, their status, and checkout records.
- Shop Staff: A staff member on shift who can approve a training override.

**Trigger(s)**
- Member taps their badge at the Kiosk.

**Basic Path**

| Step | Actor | Action |
| --- | --- | --- |
| 1. | Member | Taps badge on the Kiosk reader |
| 2. | Kiosk | Requests the member record from Member Database using the badge ID |
| 3. | Member Database | Returns membership status and completed safety trainings |
| 4. | Kiosk | Verifies the membership is active |
| 5. | Kiosk | Prompts Member to scan a tool |
| 6. | Member | Scans the tool's RFID tag at the Kiosk |
| 7. | Kiosk | Requests the tool record from Inventory |
| 8. | Inventory | Returns tool name, status, required training, and loan period |
| 9. | Kiosk | Checks that the tool's status is Available |
| 10. | Kiosk | Checks that Member has the tool's required training |
| 11. | Kiosk | Asks Member to confirm checkout of [TOOL_NAME], due back at [DUE_TIME] |
| 12. | Member | Confirms checkout |
| 13. | Kiosk | Sends the checkout to Inventory |
| 14. | Inventory | Records the checkout (tool ID, member ID, checkout time, due time, and override approver ID if one was set) and sets tool status to Checked Out |
| 15. | Kiosk | Displays the checkout confirmation with the due time |
| | | END OF USE CASE |

**Alternate Paths**

- Alternate Path A6a (from Basic Path #6): Tool tag won't scan
  - A6a.1 **Member:** Selects "Enter tool ID" and types the ID printed on the tool.
  - A6a.2 Use case continues at Basic Path #7.

- Alternate Path A6b (from Basic Path #6): Member cancels before scanning
  - A6b.1 **Member:** Selects Cancel.
  - A6b.2 **Kiosk:** Signs **Member** out and returns to the badge-in screen.
  - A6b.3 End of use case.

- Alternate Path A12 (from Basic Path #12): Member checks out another tool
  - A12.1 **Member:** Confirms checkout and selects "Add another tool."
  - A12.2 **Kiosk:** Sends the checkout to **Inventory**.
  - A12.3 **Inventory:** Records the checkout and sets tool status to Checked Out.
  - A12.4 Use case continues at Basic Path #5.

**Exception Paths**

- Exception Path E4 (from Basic Path #4): Membership is inactive
  - E4.1 **Kiosk:** Finds the membership status is inactive.
  - E4.2 **Kiosk:** Shows "Your membership is inactive. Please see the front desk."
  - E4.3 End of use case.

- Exception Path E7 (from Basic Path #7): Inventory does not respond
  - E7.1 **Inventory:** Does not respond within [TIMEOUT_SECONDS].
  - E7.2 **Kiosk:** Shows "Checkout is unavailable. Please use the paper log at the front
    desk."
  - E7.3 End of use case.

- Exception Path E9 (from Basic Path #9): Inventory shows the tool as already checked out
  - E9.1 **Kiosk:** Finds the tool status is Checked Out under another member.
  - E9.2 TBD

- Exception Path E10 (from Basic Path #10): Member lacks the required training
  - E10.1 **Kiosk:** Finds no record of the tool's required training for **Member**.
  - E10.2 **Kiosk:** Shows the missing training and offers "Request staff override."
  - E10.3 **Member:** Requests a staff override.
  - E10.4 **Kiosk:** Alerts **Shop Staff** on shift.
  - E10.5 **Shop Staff:** Badges in at the **Kiosk**.
  - E10.6 **Shop Staff:** Approves the override.
  - E10.7 **Kiosk:** Attaches the approving staff ID to the pending checkout.
  - E10.8 Use case continues at Basic Path #11.

**Post-Condition(s)**
- **Basic Path exit:** Inventory contains a checkout record with the tool ID, member ID,
  checkout time, due time, and override approver ID (blank unless E10 ran), and the tool's
  status is Checked Out.
- **Alternate Path A6b exit (cancel):** No new checkout record exists; the tool's status in
  Inventory is unchanged.
- **Exception Path E4 exit (inactive membership):** No new checkout record exists; Kiosk
  shows the badge-in screen.
- **Exception Path E7 exit (Inventory unavailable):** No new checkout record exists; the
  tool's status in Inventory is unchanged.

**Open Issues/Notes**
- E10: what happens if Shop Staff declines the override, or no staff member responds within
  a set time?
- E10.4: how does the Kiosk alert Shop Staff (sound at the kiosk, message to a staff phone)?
- E9: a tool marked Checked Out but physically on the shelf usually means a missed return.
  Decide whether the Kiosk closes the old checkout, blocks the new one, or flags both for
  staff.
- Loan periods come from Inventory per tool. Confirm whether members can request a longer
  period.
