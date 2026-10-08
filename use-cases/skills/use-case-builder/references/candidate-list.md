# Candidate Use Case List Format

This is a scoping artifact, not a use case. It exists to agree on what set of use cases an
initiative needs before spending time writing each one out in full.

## Table format

| Name | Summary | Rough Actors | Rough Trigger |
| --- | --- | --- | --- |
| `<Use Case Name>` | One sentence. | Comma-separated, usually 2-6 actors. | Blank if it continues from another candidate. |

## Conventions

- **Name** must be short enough to become the eventual `Use Case: <Short Name>` title
  as-is — don't write a sentence here.
- **Summary** is one sentence: what the actor is doing and why, same shape as the full use
  case's opening line.
- **Rough Actors** should reuse the same name for the same real-world thing across every
  row in the table. If two rows both involve "the backend platform," decide on one name for
  it now (e.g. "Platform"). The full use case format requires this consistency, so fixing it
  here avoids rework.
- **Rough Actors** has no hard limit, but 2-6 is typical. A list much longer than that
  usually means the candidate is two flows. A single-actor flow, common for internal
  systems, should name the system's modules or services as separate actors instead.
- **Rough Trigger** is left blank when a candidate is really a continuation of another
  candidate's flow rather than its own externally-triggered entry point. A blank Rough
  Trigger is a signal the two candidates might actually be one use case with an Alternate
  Path, not two — flag it for the user to confirm during review.
- Order the table in a rough natural sequence when one exists (setup/onboarding first,
  primary flow next, then supporting/error-recovery flows) — this ordering becomes the
  suggested drafting order for the full use cases.

## Worked Example

**Initiative:** RFID plate tracking for a conveyor-belt restaurant. Each plate carries an RFID
tag, so the kitchen knows which menu item is on each plate and how long it has been on the
belt.

**Goals:**
- Associate each plate with a menu item when it leaves the kitchen.
- Pull plates that stay on the belt past their time limit.
- Total a guest's bill from the plates at their seat.

**Out of scope (for this pass):** payment processing, menu management.

| Name | Summary | Rough Actors | Rough Trigger |
| --- | --- | --- | --- |
| Chef Input (Commissioning) | The chef commissions a freshly made menu item by associating its RFID-tagged plates with that item in the system. | Chef, System | Chef has made a menu item and wants to commission it for the belt. |
| Expired Plate Removal | The system flags plates that have passed their time limit so floor staff can pull them from the belt. | System, Floor Staff | A plate passes its time limit on the belt. |
| Guest Checkout | The cashier totals a guest's bill from the RFID-tagged plates at their seat. | Guest, Cashier, System | Guest asks for the check. |
| Plate Decommissioning | The system clears a plate's menu item association once the plate is returned for washing. | Dishwasher, System | |

Notes for review with the user:
- "Plate Decommissioning" has no Rough Trigger because it continues from Guest Checkout and
  Expired Plate Removal. Confirm whether it should stay a standalone use case that both link
  to (recommended, since two flows end with the same step) or become a shared final step in
  each.
- "System" covers the RFID reader, the Chef Interface, and the Live Inventory together.
  Confirm that splitting them into separate actors isn't needed for any of these flows
  before drafting.
