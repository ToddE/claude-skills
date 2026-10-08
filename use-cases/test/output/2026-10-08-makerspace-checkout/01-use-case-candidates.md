# Candidate Use Cases: Foundry Makerspace Tool Checkout

**Initiative:** Self-service tool checkout for Foundry Makerspace, a member-run shop with
about 300 members. Members badge in at a kiosk, scan a tool's RFID tag, and take it home
for a set loan period. The kiosk checks that the member has completed the safety training
the tool requires. This replaces a paper sign-out binder at the front desk.

**Goals:**
- Record who has each tool and when it is due back.
- Block checkout of tools that need safety training the member hasn't completed.
- Remind members about overdue tools without staff chasing them by hand.

**Out of scope (for this pass):** late fees, tool reservations, maintenance scheduling.

| Name | Summary | Rough Actors | Rough Trigger |
| --- | --- | --- | --- |
| Member Tool Checkout | A member checks out a tool at the kiosk so the makerspace knows who has it and when it is due back. | Member, Kiosk, Member Database, Inventory, Notification Service | Member taps their badge at the Kiosk. |
| Tool Return | A member returns a tool at the kiosk so it shows as available again. | Member, Kiosk, Inventory | Member scans a tool at the return shelf. |
| Overdue Tool Reminder | Inventory reminds a member to return a tool that has passed its due time, and alerts shop staff if it stays overdue. | Inventory, Notification Service, Member, Shop Staff | A checkout passes its due time with no return recorded. |
| Training Record Update | Shop staff record a member's completed safety training so the kiosk can allow checkout of tools that require it. | Shop Staff, Member Database | Member finishes a safety class. |

Notes for review with the user:
- "Inventory" replaces "Tool Database" from the intake, per the user's review, so the name
  matches what the shop already calls its tool list.
- Member Tool Checkout lists five rough actors. That's within the usual 2-6, and Member
  Database and Inventory are separate systems at Foundry that both act in the flow.
