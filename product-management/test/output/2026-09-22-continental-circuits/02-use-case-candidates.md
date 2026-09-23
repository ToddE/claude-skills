# Initiative: Continental Circuits Chip Sourcing & Production System

**What is it:** The internal software system Continental Circuits uses to qualify chip
suppliers against its U.S./EU sourcing policy, maintain the approved-vendor list (AVL) for
every chip in the Trustpoint Hub's bill of materials, and allocate qualified chip inventory
to scheduled production runs at the Zanesville factory.

**Goals:**
- Verify a candidate chip supplier's fab location, export-control classification, and
  capacity before any part number from that supplier can enter the bill of materials.
- Maintain a single approved-vendor list per component category so production planning
  never allocates an unqualified part to a run.
- Allocate on-hand and incoming qualified chip inventory to scheduled production runs
  without over-committing a constrained part.
- Surface a chip shortage early enough that Sourcing can qualify a backup supplier or
  expedite incoming stock before it blocks a run.
- Generate the country-of-origin attestation the PR/FAQ commits to shipping with every
  production lot, directly from qualification and allocation records, not a manually
  assembled document.

**Out of scope (for this initiative):** the physical assembly line's own tooling and
work-instruction systems, the factory's HR/safety onboarding system, retail/reseller
ordering and fulfillment.

## Candidate Use Cases

| Name | Summary | Rough Actors | Rough Trigger |
| --- | --- | --- | --- |
| Qualify a New Chipset Supplier | Sourcing and Compliance vet a candidate chip supplier's fab location and export-control status before it can be used in production. | Sourcing Manager, Candidate Supplier, Compliance Officer, Continental ERP | Sourcing Manager initiates a supplier qualification request. |
| Allocate Chipset Inventory to a Production Run | Continental ERP reserves qualified chip inventory against a scheduled production run and escalates a shortage before it blocks the line. | Production Planner, Continental ERP, Sourcing Manager, Assembly Line | Production Planner schedules a new production run. |
| Generate Country-of-Origin Attestation for a Shipment | Continental ERP compiles a shipped lot's qualification and allocation records into the attestation document that ships with the unit. | Continental ERP, Compliance Officer, Shipping Coordinator | A production lot is marked ready to ship. |
| Escalate a Chipset Allocation Shortage | Sourcing Manager responds to a shortage flagged during production run allocation by expediting stock or qualifying a backup supplier. | Sourcing Manager, Continental ERP, Candidate Supplier | |
| Receive and Inspect an Incoming Chipset Shipment | A receiving clerk logs an incoming shipment from a qualified supplier and inspects it against the purchase order before it enters usable inventory. | Receiving Clerk, Continental ERP, Qualified Supplier | Qualified Supplier's shipment arrives at the dock. |
| Suspend a Qualified Supplier | Compliance Officer removes a previously qualified supplier from the approved-vendor list after a compliance or quality failure. | Compliance Officer, Continental ERP, Sourcing Manager | A compliance or quality failure is reported for a qualified supplier. |

## Notes for review

- "Escalate a Chipset Allocation Shortage" has no Rough Trigger because it only ever starts
  as a continuation of "Allocate Chipset Inventory to a Production Run" once that use case's
  allocation step comes up short; it never fires on its own. Recommend folding it into that
  use case as an Exception Path rather than drafting it standalone, the same call the
  DispatchIQ example run made for its own no-trigger candidate ("Re-Route on Technician
  Delay"). Confirmed with the user; folded in during drafting (see `03b`).
- "Qualify a New Chipset Supplier" and "Suspend a Qualified Supplier" are closely related
  (both change AVL membership) but genuinely different flows: one is a forward-looking
  approval gate with a supplier actively participating, the other is a reactive removal
  triggered by a failure report, with no supplier action at all. Keeping them separate
  rather than merging.
- Actor names are consistent across every row: "Sourcing Manager," "Compliance Officer,"
  "Continental ERP," "Production Planner," and "Assembly Line" always mean the same thing.
  "Candidate Supplier" (pre-qualification) and "Qualified Supplier" (post-qualification) are
  deliberately different actor names for the same real-world company at two different
  trust states; use-case-uml's consistency check should treat these as distinct actors, not
  a naming inconsistency to flag.
- Selected for full drafting this run: "Qualify a New Chipset Supplier" and "Allocate
  Chipset Inventory to a Production Run" (with the shortage escalation folded in as its
  Exception Path). These two share two actors (Sourcing Manager, Continental ERP) end to
  end, which exercises use-case-uml's actor-consistency check across documents directly.
