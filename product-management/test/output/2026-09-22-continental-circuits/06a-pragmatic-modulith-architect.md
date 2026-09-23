# Architect Review: Continental Circuits Chip Sourcing & Production System

**Persona**: The Pragmatic Modulith Architect

**Inputs considered**: PR/FAQ (`01-prfaq.md`), two use cases (`03a-qualify-a-new-chipset-supplier.md`, `03b-allocate-chipset-inventory-to-a-production-run.md`), nineteen functional requirements (`05a`, `05b`). No infrastructure or team-size details beyond what the PR/FAQ states.

**Scope note**: this review covers the software system behind the use cases, supplier qualification, the approved-vendor list, and production-run allocation, not the factory's physical assembly-line tooling, work-instruction systems, or building infrastructure. Those aren't architecture-review topics; they're capital equipment and industrial-engineering decisions this recommendation doesn't touch.

## Recommended Approach

Build Continental ERP as a single Go modulith with three internal modules sharing one PostgreSQL database: supplier qualification, approved-vendor list, and production-run allocation. All three modules read and write the same source of truth, and the country-of-origin attestation the PR/FAQ commits to shipping with every lot is a query against that one database, not a document assembled by hand from three separate systems. That traceability requirement, not team size, is the strongest argument for keeping this integrated rather than splitting it into separate services.

Treat the qualification-case and approved-vendor-list records as append-only: a rejection, an approval, or a supplier suspension gets a new row, never an edit-in-place on an old one. A procurement office reviewing an attestation is effectively auditing this data; a system that lets a past qualification decision be silently edited undermines the entire claim the PR/FAQ is making. This is the compliance-by-design instinct applied directly, not as an afterthought once an auditor asks.

Deploy on EC2 or Fargate behind an ALB rather than fly.io. The customer base named in the PR/FAQ, government and critical-infrastructure procurement, makes hosting jurisdiction and data-residency questions likely to come up in a due-diligence conversation sooner than they would for a typical early-stage product; AWS gives a defensible answer about region and access controls today, without needing Kubernetes or a multi-region setup this team doesn't need yet.

## Key Tradeoffs

- **Risk**: append-only records for qualification and AVL history mean every read path has to account for superseded rows (e.g., "current AVL status" is a query, not a column), adding real query complexity for a two-or-three-person engineering team to get right.
  **Driver**: the attestation's credibility depends on qualification history being provably unaltered; a mutable record undermines that the moment anyone asks how to verify it.
  **Mitigation**: keep the query complexity behind one well-tested module (`AVL status lookup`), so every other part of the system, including allocation, calls that module instead of re-deriving "current status" logic in multiple places.
  **Accepted**: yes. This is the correct tradeoff for a system whose entire value proposition is an auditable record, not a nice-to-have.

- **Risk**: REQ-AllocateChips-08/09's shortage-flagging logic and REQ-AllocateChips-07's lot-expiration tie-break both depend on inventory and lot data whose structure isn't fully specified yet (`[JOB_LOAD_LIMIT]`-equivalent gaps noted in `05b`'s Gaps section).
  **Driver**: the use case was written before the inventory data model was finalized.
  **Mitigation**: build the allocation module's interface (what it needs to know about a chip lot) before the underlying inventory schema is locked, so the schema question doesn't block writing and testing the allocation logic itself.
  **Accepted**: yes, with the explicit condition that lot-tracking scope (which chip categories have expiration data) gets resolved before REQ-AllocateChips-07 ships, not discovered in production.

## Risks / Open Questions

- `[DOCUMENTATION_DEADLINE]`: both `03a`'s Exception Path B and its requirements depend on this value; unspecified today.
- Whether every bill-of-materials chip category is lot-tracked with expiration data, or only some (the use case's own Open Issues/Notes flags this); changes how much of REQ-AllocateChips-07 is real logic versus a fallback rule for untracked categories.
- The PR/FAQ names chip allocation risk (industry-wide constraint, U.S./EU sourcing removes the largest alternate-supplier pool) as the top business risk. This system's job is to surface a shortage early (`REQ-AllocateChips-08/09`); it can't solve the underlying allocation-constraint problem, only make it visible in time for Sourcing to act. Worth saying plainly so the software system isn't mistaken for a fix to a physical supply problem.
- Data residency and access-control requirements for customers in the government/critical-infrastructure segment aren't specified in the PR/FAQ beyond the sourcing-attestation claim itself; if a specific customer segment later requires a specific hosting certification, this recommendation's AWS choice should be revisited against that named requirement, not assumed to already satisfy it.

## Alternatives Considered

- **Separate microservices for qualification, AVL, and allocation**: rejected. No present-tense team-ownership or scaling reason; splitting would also make the single-source-of-truth attestation query harder to write correctly, working against the system's core requirement rather than for it.
- **fly.io for early-stage simplicity**: rejected here specifically, unlike a typical early-stage recommendation, because of the procurement-facing data-residency question this customer segment is more likely than most to raise.
- **Mutable AVL records with a separate audit-log table**: rejected. An audit log bolted onto a mutable table is weaker than making the record itself append-only; it invites exactly the "was this edited after the fact" question a procurement office might ask.
