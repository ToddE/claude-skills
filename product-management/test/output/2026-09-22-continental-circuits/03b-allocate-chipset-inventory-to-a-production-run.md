## Use Case: Allocate Chipset Inventory to a Production Run

Continental ERP reserves qualified chip inventory against a newly scheduled production run, and Sourcing responds if a required chip can't be fully covered before the run starts.

**Assumptions**
- Every chip in the Trustpoint Hub's bill of materials has at least one approved-vendor-list entry (see [Use Case: Qualify a New Chipset Supplier](#qualify-a-new-chipset-supplier)).
- The production run's unit quantity and target start date are already known.

**Actors**
- Production Planner: Schedules production runs and releases fully allocated runs to the Assembly Line.
- Continental ERP: Calculates required chip quantities, checks inventory against the approved-vendor list, and reserves stock for a run.
- Sourcing Manager: Responds to an allocation shortage by expediting incoming stock or qualifying a backup supplier.
- Assembly Line: Consumes reserved chip inventory as it builds units for the run.

**Trigger(s)**
- Production Planner schedules a new production run.

**Basic Path**

| Step | Actor | Action |
| --- | --- | --- |
| 1. | Production Planner | Schedules a production run with a target unit quantity and start date |
| 2. | Continental ERP | Calculates the required quantity of each bill-of-materials chip (applications processor, radio SoC, cellular modem, secure element) for the run |
| 3. | Continental ERP | Checks on-hand and incoming inventory for each required chip against approved-vendor-list suppliers |
| 4. | Continental ERP | Reserves the required quantity of each chip against the run |
| 5. | Continental ERP | Notifies the Sourcing Manager of the confirmed allocation for chips flagged as supply-constrained, so Sourcing can track consumption against each supplier's committed capacity |
| 6. | Sourcing Manager | Acknowledges the allocation notice; no action needed on a fully-covered run |
| 7. | Production Planner | Confirms the run is fully allocated and releases it to the Assembly Line |
| 8. | Assembly Line | Consumes reserved chip inventory as units are built |
| | | END OF USE CASE |

**Alternate Paths**

- Alternate Path (from Basic Path #3): Two approved suppliers both have sufficient stock for the same chip
  3. Continental ERP: Determines two or more approved-vendor-list suppliers can each fully cover the required quantity of the same chip.
  4. Continental ERP: Reserves from the supplier whose qualified lot has the nearer expiration or shorter remaining shelf life, breaking the tie.
  5. Use case continues at Basic Path #4.

**Exception Paths**

- Exception Path (from Basic Path #3): On-hand and incoming inventory can't fully cover a required chip
  3. Continental ERP: Determines on-hand plus incoming inventory for a required chip, across all approved-vendor-list suppliers, is less than the run's required quantity.
  4. Continental ERP: Flags the run as partially allocated and notifies the Sourcing Manager of the specific chip and shortfall quantity.
  5. Sourcing Manager: Expedites incoming stock from an already-approved supplier, or initiates qualification of a backup supplier ([Use Case: Qualify a New Chipset Supplier](#qualify-a-new-chipset-supplier)) if no approved supplier can close the gap in time.
  6. Sourcing Manager: Reports the resolved quantity and expected availability date back to Continental ERP.
  7. Use case continues at Basic Path #3.

- Exception Path (from Basic Path #3): Shortfall can't be resolved before the run's start date
  3. Sourcing Manager: Determines no approved supplier, expedited or newly qualified, can close the shortfall before the scheduled start date.
  4. Sourcing Manager: Notifies the Production Planner that the shortfall is unresolved.
  5. Production Planner: Reduces the run's unit quantity to what available inventory supports, or reschedules the run's start date.
  6. Use case continues at Basic Path #1.

**Post-Condition(s)**
- **Basic Path exit:** Continental ERP shows the run as fully allocated, with reserved-inventory records for every required chip tied to the run, and the Assembly Line's work queue includes the run.
- **Exception Path B exit (shortfall unresolved before start date):** The run's original quantity and start date are not carried forward; a revised run record exists at a reduced quantity, a later start date, or both, with no reserved-inventory record for the un-covered chip.

**Open Issues/Notes**
- The Alternate Path's tie-break rule (nearer lot expiration) assumes chip inventory is lot-tracked with expiration or shelf-life data; unconfirmed whether that applies to every chip category in the bill of materials or only some (e.g., secure elements with provisioning windows).
- Exception Path A's rejoin at Basic Path #3 assumes Continental ERP re-runs the inventory check rather than resuming from the partial reservation already made; whether partial reservations are held or released while Sourcing works the shortage isn't specified yet.
