## Use Case: Qualify a New Chipset Supplier

Sourcing and Compliance vet a candidate chip supplier's fab location, export-control status, and capacity before any of its part numbers can enter the Trustpoint Hub's bill of materials.

**Assumptions**
- The component category (applications processor, radio SoC, cellular modem, or secure element) the candidate supplier would fill is already defined in Continental ERP.
- Continental Circuits' sourcing policy (fab must be in the U.S. or EU; supplier must not appear on the FCC Covered List) is already configured in Continental ERP.

**Actors**
- Sourcing Manager: Identifies candidate suppliers and initiates qualification requests.
- Candidate Supplier: The prospective chip vendor being evaluated; not yet trusted for production use.
- Compliance Officer: Reviews qualification documentation against sourcing policy and export-control requirements, and approves or rejects the candidate.
- Continental ERP: Tracks the qualification case, requests documentation, and maintains the approved-vendor list (AVL).

**Trigger(s)**
- Sourcing Manager initiates a qualification request for a candidate supplier.

**Basic Path**

| Step | Actor | Action |
| --- | --- | --- |
| 1. | Sourcing Manager | Submits a qualification request naming the candidate supplier and the component category |
| 2. | Continental ERP | Creates a qualification case and requests fab-location, export-control classification (ECCN), and capacity documentation from the Candidate Supplier |
| 3. | Candidate Supplier | Submits the requested documentation |
| 4. | Compliance Officer | Reviews the documentation against sourcing policy (fab location, FCC Covered List status, export-control classification) |
| 5. | Compliance Officer | Approves the candidate supplier |
| 6. | Continental ERP | Adds the supplier and its part number(s) to the approved-vendor list for the component category |
| 7. | Sourcing Manager | Sees the supplier available for allocation in production planning |
| | | END OF USE CASE |

**Alternate Paths**

- Alternate Path (from Basic Path #4): Documentation is incomplete
  4. Compliance Officer: Determines the submitted documentation doesn't fully cover fab location, export-control classification, or capacity.
  5. Continental ERP: Requests the specific missing documentation from the Candidate Supplier.
  6. Candidate Supplier: Submits the additional documentation.
  7. Use case continues at Basic Path #4.

**Exception Paths**

- Exception Path (from Basic Path #4): Candidate supplier fails sourcing policy
  4. Compliance Officer: Determines the candidate's fab is outside the U.S./EU, or the supplier appears on the FCC Covered List.
  5. Compliance Officer: Rejects the candidate supplier and records the specific policy failure.
  6. Continental ERP: Notifies the Sourcing Manager of the rejection and the reason.
  7. End of use case.

- Exception Path (from Basic Path #3): Candidate supplier does not respond within [DOCUMENTATION_DEADLINE]
  3. Continental ERP: Marks the qualification case as stalled after the documentation deadline passes with no submission.
  4. Continental ERP: Notifies the Sourcing Manager that the candidate has not responded.
  5. Sourcing Manager: Decides whether to extend the deadline or close the case.
  6. End of use case.

**Post-Condition(s)**
- **Basic Path exit:** The approved-vendor list contains a new entry linking the supplier and its part number(s) to the component category, and the supplier is selectable in production-run allocation.
- **Exception Path A exit (policy failure):** The qualification case is recorded as rejected with the specific policy reason; the approved-vendor list is unchanged and the supplier is not selectable in allocation.
- **Exception Path B exit (no response):** The qualification case is recorded as stalled or closed; the approved-vendor list is unchanged.

**Open Issues/Notes**
- `[DOCUMENTATION_DEADLINE]`: how long Continental ERP waits for a non-responsive candidate before flagging the case as stalled isn't specified yet.
- Whether a rejected candidate can be resubmitted later (e.g., after changing its fab location) or is permanently barred isn't specified; affects whether Continental ERP needs a "resubmission" state distinct from a fresh qualification request.
