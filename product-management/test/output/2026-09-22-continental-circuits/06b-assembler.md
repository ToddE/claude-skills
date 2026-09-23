# Architect Review: Continental Circuits Chip Sourcing & Production System

**Persona**: The Assembler

**Inputs considered**: same as `06a-pragmatic-modulith-architect.md`.

**Scope note**: same as `06a`; this covers the software system behind supplier qualification, the approved-vendor list, and production-run allocation, not the physical factory line.

## Recommended Approach

Continental Circuits' capital is going into the Zanesville facility, tooling, and chip inventory, not software, and the PR/FAQ says so directly: the factory is capital-intensive and largely spent before the first unit ships. That argues for buying the qualification and quality-management workflow rather than building it. A supplier-quality-management platform (the category SAP Ariba Supplier Lifecycle and Performance and similar PLM/SQM tools serve) already models supplier onboarding, document collection, and approval workflows close to what `03a` describes: a qualification case, a documentation request, a review-and-approve step, an approved-vendor list. Configuring that workflow is faster than building REQ-QualifySupplier-01 through 08 from scratch, and the vendor's own audit trail is a feature these platforms are built around, not something to bolt on.

For production-run allocation (`03b`), that logic, calculating required chip quantities against a bill of materials and reserving from qualified inventory, is closer to Continental Circuits' own operational judgment than a solved problem a vendor already ships well. Build this piece: a small service on a managed platform (a backend-as-a-service for the database and scheduled jobs) that reads the approved-vendor list from the SQM platform's API rather than duplicating supplier data in two places.

## Key Tradeoffs

1. **Name the dependency**: a supplier-quality-management platform for qualification and the AVL, a backend-as-a-service for the allocation logic. Two vendor dependencies plus one owned module, not zero and not four.
2. **Switching cost today**: low for the backend-as-a-service (allocation logic is new and small). Higher for the SQM platform once qualification history and supplier documents live there, since exporting years of audit-relevant records to a new vendor is not a same-week project.
3. **What buying saves**: the SQM platform saves building and maintaining a document-collection and approval workflow, exactly the kind of solved problem a vendor already does well, tested by thousands of other companies' supplier-qualification programs, not just Continental Circuits' own. Netted against a real cost specific to this business: qualification documents include export-control classification and fab-location data, and putting that in a vendor's hands means trusting their access controls and subprocessor list for data this company's entire market position depends on. That's a heavier version of the usual vendor-trust tradeoff, not the usual one.
4. **Revisit trigger**: if the SQM platform's data-handling terms can't be made to satisfy a specific customer's due-diligence requirement once one is named, or if qualification volume grows enough that the platform's per-supplier pricing becomes a meaningful cost, revisit that one dependency on its own economics.

## Risks / Open Questions

- `[DOCUMENTATION_DEADLINE]`: same gap `06a` names; a vendor platform still needs this business rule configured, it doesn't come pre-decided.
- Whether a supplier-quality-management vendor's standard contract terms are compatible with keeping export-control-sensitive documentation (ECCNs, fab locations) under the access controls this business's own positioning implies isn't verified by the input artifacts; needs confirming against the specific vendor's terms, not assumed here.
- Same open question `06a` raises about lot-tracking scope for REQ-AllocateChips-07; the allocation service needs an answer regardless of which architecture builds it.

## Alternatives Considered

- **Build supplier qualification and the AVL in-house**: rejected for now. This is a document-collection-and-approval workflow, a mature, well-solved problem category, and building it spends engineering time a factory-stage team needs for the allocation logic that's actually specific to Continental Circuits.
- **Buy an off-the-shelf allocation/MRP module instead of building one**: considered, but most MRP allocation modules assume unconstrained or lightly-constrained supply; the tie-break and shortage-escalation logic in `03b` (REQ-AllocateChips-07 through 10) is specific enough to this business's allocation-constrained chip categories that configuring a generic MRP tool around it isn't clearly faster than building a small, purpose-built module.
